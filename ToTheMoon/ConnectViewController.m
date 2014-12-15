//
//  ConnectViewController.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 7/9/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import "ConnectViewController.h"
#import "ViewController.h"

@interface ConnectViewController ()
- (IBAction)connectBot:(id)sender;

@end

@implementation ConnectViewController
{
    RFduinoManager *rfduinoManager;
    BOOL controllerConnected;
    RFduino *theController;
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
    rfduinoManager = [RFduinoManager sharedRFduinoManager];
    rfduinoManager.delegate = self;
    controllerConnected = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Connect appearing");
    [self.connectButton setImage: [UIImage imageNamed:@"avatar_off.png"] forState:UIControlStateNormal];
    controllerConnected = NO;
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
 
    [segue.destinationViewController setBleRadio:rfduinoManager withController:theController from:self];
}

- (IBAction)connectBot:(id)sender
{
    if(!controllerConnected)
    {
        [self.connectButton setEnabled:NO];
        NSLog(@"Scanning for RFDuinos");
        [rfduinoManager startScan];
        const int timeOut = 2; //seconds
        [NSTimer scheduledTimerWithTimeInterval:(float)timeOut target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    }
    else
    {
        [self performSegueWithIdentifier:@"Associate" sender:sender];
    }
}

-(void) scanTimer:(NSTimer *)timer
{
    [rfduinoManager stopScan];
    [self.connectButton setEnabled:YES];
    NSLog(@"Finished scanning for RFDuinos");
}

/* RFduinoManager Delegate */
- (void)didDiscoverRFduino:(RFduino *)rfduino
{
    NSString *adData = [[NSString alloc] initWithData:rfduino.advertisementData encoding:NSASCIIStringEncoding];
    NSLog(@"Found RFduino %@ - %@", rfduino.name, adData);
    if([rfduino.name isEqualToString:@"DynePod"] &&  [adData isEqualToString:@"001"])
    {
        NSLog(@"Controller UUID %@", rfduino.UUID);
        [rfduinoManager connectRFduino:rfduino];
    }
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
    theController = rfduino;
    NSLog(@"Controller joining!");
    controllerConnected = YES;
    [self.connectButton setImage: [UIImage imageNamed:@"avatar_on.png"] forState:UIControlStateNormal];
}
- (void)didDisconnectRFduino:(RFduino *)rfduino
{
    NSLog(@"Controller disconnected");
    controllerConnected = NO;
    [self.connectButton setImage: [UIImage imageNamed:@"avatar_off.png"] forState:UIControlStateNormal];
}
/* RFduinoDelegate */
- (void)didReceive:(NSData *)data;
{
    NSLog(@"Received the datas");
}

@end
