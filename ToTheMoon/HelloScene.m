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
#import "Controller.h"

@implementation HelloScene
{
    RFduinoManager *bluetooth;
    UIViewController *reconnectScreen;
    BOOL connected;
    SKSpriteNode *hull;
}

-(void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents
{
    if(bluetooth.rfduinos[0] != nil)
    {
        NSLog(@"Sending commands to controller");
        [Controller buzzer:bluetooth.rfduinos[0]];
        [Controller hapticShock:bluetooth.rfduinos[0]];
        RFduino *rfd = bluetooth.rfduinos[0];
        rfd.delegate = self;
        [Controller toggleAccel:bluetooth.rfduinos[0] enable:YES];
    }
    
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    //[self addChild: [self newHelloNode]];
    [self addChild: [self newBackground]];
    
    SKSpriteNode *spaceship = [self newSpaceShip];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    [self addChild: spaceship];
    
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.40 withRange:0.15]]];
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
/*    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
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
    }*/
}

-(SKSpriteNode *)newBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

    return background;
}

-(SKSpriteNode *)newSpaceShip
{
    //hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    hull = [SKSpriteNode spriteNodeWithImageNamed:@"ship.png"];
    
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
    //SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8, 80)];
    SKSpriteNode *rock = [SKSpriteNode spriteNodeWithImageNamed:@"ship_asteroid.png"];
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
    
    if(hull != nil)
    {
        SKAction *hover;
        //move hull based on accel
        /*if(sensibot.accelY > 35)
        {
            if(!(hull.position.x > 748))
            {
                NSLog(@"#############################################");
                hover = [SKAction moveByX:-5 y:0.0 duration:0.1];
            }
        }
        else
        {
            if(!(hull.position.x < 5))
            {
                NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                hover = [SKAction moveByX:5 y:0.0 duration:0.1];
            }
        }
        [hull runAction: hover];
        */
    }
}


/* RFduinoManager Delegate */
- (void)didDiscoverRFduino:(RFduino *)rfduino
{
    NSLog(@"Found RFduino %@", rfduino.name);
}
- (void)didUpdateDiscoveredRFduino:(RFduino *)rfduino
{
    NSLog(@"Update Discovered?");
}
- (void)didConnectRFduino:(RFduino *)rfduino
{
    NSLog(@"Controller connected");
}
- (void)didLoadServiceRFduino:(RFduino *)rfduino
{
    NSLog(@"Controller joining!");
}
- (void)didDisconnectRFduino:(RFduino *)rfduino
{
    NSLog(@"Controller disconnected");
    rfduino.delegate = nil;
    bluetooth.delegate = reconnectScreen;
    [reconnectScreen.navigationController popToRootViewControllerAnimated:YES];
}
/* RFduinoDelegate */
- (void)didReceive:(NSData *)data;
{
    NSLog(@"Received the datas");
    //convert to x,y,z axis and feed into other methods
    AccelPoint xyz = [Controller parseDatas:data];
}

-(void) setBleRadio: (RFduinoManager *) value from:(UIViewController *) connectScreen
{
    bluetooth = value;
    reconnectScreen = connectScreen;
    bluetooth.delegate = self;
}

@end
