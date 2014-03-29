//
//  ViewController.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 3/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "HelloScene.h"
#import "RBL_BLE.h"
#import "SensiBot.h"

@interface ViewController ()

@end

@implementation ViewController
{
    RBL_BLE *bluetooth;
    NSMutableArray *deviceIDs;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    
    deviceIDs = [[NSMutableArray alloc] initWithCapacity:2];
    
    bluetooth = [[RBL_BLE alloc] init];
    bluetooth.list_delegate = self;
    [bluetooth startup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [bluetooth findBLEPeripherals:2];

    HelloScene *hello = [[HelloScene alloc] initWithSize:CGSizeMake(768, 1024)];
    SKView *spriteView = (SKView *) self.view;
    
    [spriteView presentScene: hello];
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
    NSLog(@"Adding peripheral %@ to table", [identifier UUIDString]);
    
    
    //if the device disconnects, then reconnects, and changes its name, this will not pick it up
    if([deviceIDs indexOfObject:identifier] == NSNotFound)
    {
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
-(void) bleDidDisconnect:(NSUUID *) identifier
{
    NSLog(@"Removing peripheral %@ from table", [identifier UUIDString]);
    
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
