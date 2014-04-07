//
//  HelloScene.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 3/29/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import "HelloScene.h"
#import "SpaceShipScene.h"
#import "RBL_BLE.h"
#import "SensiBot.h"

@implementation HelloScene
{
    RBL_BLE *bluetooth;
    NSMutableArray *deviceIDs;
    SensiBot *sensibot;
    BOOL connected;
    SKSpriteNode *hull;
}

-(void)didMoveToView:(SKView *)view
{
    connected = NO;
    deviceIDs = [[NSMutableArray alloc] initWithCapacity:2];
    
    bluetooth = [[RBL_BLE alloc] init];
    bluetooth.detail_delegate = self;
    [bluetooth startup];

    if(!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newHelloNode]];
    
    SKSpriteNode *spaceship = [self newSpaceShip];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    [self addChild: spaceship];
    
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.10 withRange:0.15]]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
}

-(SKLabelNode *) newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.name = @"helloNode";
    helloNode.text = @"Hi, Everybody!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return helloNode;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 
    if(!connected)
    {
        [bluetooth findBLEPeripherals:2];
    }
    else
    {
        [[bluetooth.sensibots objectForKey:[[NSUUID alloc] initWithUUIDString:@SPACE_SHIP_BOT]] toggleAccelerometer:YES];
    };

    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    if(helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        //[helloNode runAction:moveSequence];
        [helloNode runAction:nil completion: ^{
            SKScene *spaceshipScene = [[SpaceShipScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
             }];
    }
}

-(SKSpriteNode *)newSpaceShip
{
    hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    
    SKAction *hover = [SKAction sequence:@[[SKAction waitForDuration: 1.0],
                                           [SKAction moveByX:100 y:50.0 duration:1.0],
                                           [SKAction waitForDuration: 1.0],
                                           [SKAction moveByX:-100.0 y:-50.0 duration:1.0]]];
    
    //[hull runAction: [SKAction repeatActionForever:hover]];
    return hull;
}

-(SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8, 8)];
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

-(void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8, 80)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y < 0)
            [node removeFromParent];
    }];
}

/*
 * RBL_BLE_Delegate
 */

-(void) bleFinishedScanning
{
    NSLog(@"Connection timer finished");
}
-(void) bleDidConnect:(NSUUID *) identifier
{
    connected = YES;
    NSLog(@"Adding peripheral %@ to table", [identifier UUIDString]);
    
    //if the device disconnects, then reconnects, and changes its name, this will not pick it up
    if([deviceIDs indexOfObject:identifier] == NSNotFound)
    {
        NSLog(@"Got here");
        sensibot = [bluetooth.sensibots objectForKey:identifier];
        /*       // Tell the tableView we're going to add (or remove) items.
         [self.tableView beginUpdates];
         // Add an item to the array.
         [deviceIDs addObject:identifier];
         
         // Tell the tableView about the item that was added.
         NSIndexPath *indexPathOfNewItem = [NSIndexPath indexPathForRow:([deviceIDs count] - 1) inSection:0];
         [self.tableView insertRowsAtIndexPaths:@[indexPathOfNewItem] withRowAnimation:UITableViewRowAnimationAutomatic];
         
         // Tell the tableView we have finished adding or removing items.
         [self.tableView endUpdates];
         
         // Scroll the tableView so the new item is visible
         [self.tableView scrollToRowAtIndexPath:indexPathOfNewItem atScrollPosition:UITableViewScrollPositionBottom animated:YES];
         
         // Update the buttons if we need to.
         //[self updateButtonsToMatchTableState];
         */
    }
    
}
-(void) bleDidFinishedConnecting:(NSUUID *) identifier
{
    NSString * idString = [identifier UUIDString];
    if([idString caseInsensitiveCompare:@SPACE_SHIP_BOT] == NSOrderedSame)
    {
        NSLog(@"Space Ship bot joining");
        [[bluetooth.sensibots objectForKey:[[NSUUID alloc] initWithUUIDString:@SPACE_SHIP_BOT]] toggleAccelerometer:YES];

/*        [self.sbDetailButton setEnabled:YES];
        [self.sbDetailButton setImage: [UIImage imageNamed:@"avatar_sound_on.png"] forState:UIControlStateNormal];
        [self.sbBuzzer setEnabled:YES];
        [self.sbLED setEnabled:YES];
        [[bluetooth.sensibots objectForKey:[[NSUUID alloc] initWithUUIDString:@SOUND_BOT]] toggleSound:YES];
        [self.sbValue setEnabled:YES];
        [self.sbGraph startAnimating];
*/
    }
}
-(void) bleDidReceiveData
{
//    sensibot.accelX;
//    tempValue.text = [NSString stringWithFormat:@"%f", sensibot.temperature];
    NSLog(@"%@",[NSString stringWithFormat:@"(X,Y,Z) = (%.3f,%.3f,%.3f)", sensibot.accelX, sensibot.accelY, sensibot.accelZ]);
    
    if(hull != nil)
    {
        SKAction *hover;
        if(sensibot.accelY > 5)
        {
            if(!(hull.position.x > 748))
            {
                NSLog(@"#############################################");
                hover = [SKAction moveByX:-1 y:0.0 duration:0.1];
            }
        }
        else
        {
            if(!(hull.position.x < 0))
            {
                NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                hover = [SKAction moveByX:1 y:0.0 duration:0.1];
            }
        }
        [hull runAction: hover];
    }
//    lightValue.text = [NSString stringWithFormat:@"%f", sensibot.lux];
//    soundValue.text = [NSString stringWithFormat:@"%f", sensibot.db];
}

-(void) bleDidDisconnect:(NSUUID *) identifier
{
    NSLog(@"Removing peripheral %@ from table", [identifier UUIDString]);
    connected = NO;
    //sensibot = nil;
    
    NSUInteger location = [deviceIDs indexOfObject:identifier];
    
    if(location == NSNotFound)
        return;
    
    /*    // Tell the tableView we're going to add (or remove) items.
     [self.tableView beginUpdates];
     
     // Tell the tableView about the item that was added.
     NSIndexPath *indexPathOfNewItem = [NSIndexPath indexPathForRow:location inSection:0];
     [self.tableView deleteRowsAtIndexPaths:@[indexPathOfNewItem] withRowAnimation:UITableViewRowAnimationAutomatic];
     
     // Remove an item to the array.
     [deviceIDs removeObject:identifier];
     
     // Tell the tableView we have finished adding or removing items.
     [self.tableView endUpdates];
     */
}
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    // No reason to update
}

@end
