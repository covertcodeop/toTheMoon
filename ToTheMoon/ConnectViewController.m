//
//  ConnectViewController.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 7/9/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import "ConnectViewController.h"
#import "ViewController.h"
#import "RBL_BLE.h"
#import "SensiBot.h"

@interface ConnectViewController ()
- (IBAction)connectBot:(id)sender;

@end

@implementation ConnectViewController
{
    RBL_BLE *bluetooth;
    NSUUID *toyIdentifier;
    SensiBot *bot;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bluetooth = [[RBL_BLE alloc] init];
    [bluetooth startup];
    bluetooth.list_delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 //[bluetooth.listOfDelegates removeObjectForKey:[self class]];
 
 [segue.destinationViewController setBleRadio:bluetooth forDevice:toyIdentifier from:self];
}

- (IBAction)connectBot:(id)sender
{
    if(toyIdentifier == nil)
    {
        [self.connectButton setEnabled:NO];
        [bluetooth findBLEPeripherals:2];
    }
    else
    {
        [self performSegueWithIdentifier:@"Associate" sender:sender];
    }
}

/*
 * RBL_BLE_Delegate
 */

-(void) bleFinishedScanning
{
    [self.connectButton setEnabled:YES];
}
-(void) bleDidConnect:(NSUUID *) identifier
{
    // Add an item to the array.
    toyIdentifier = identifier;
}
-(void) bleDidFinishedConnecting:(NSUUID *) identifier
{
    NSLog(@"Bot joining!");
    bot = [bluetooth.sensibots objectForKey:identifier];
    [self.connectButton setImage: [UIImage imageNamed:@"avatar_on.png"] forState:UIControlStateNormal];
}
-(void) bleDidDisconnect:(NSUUID *) identifier
{
    toyIdentifier = nil;
    bot = nil;
    [self.connectButton setImage: [UIImage imageNamed:@"avatar_off.png"] forState:UIControlStateNormal];
}

-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    
}
-(void) bleDidReceiveData
{
    NSLog(@"Receiving data on the Connect screen... not sure what's up.");
}

@end
