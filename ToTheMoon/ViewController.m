//
//  ViewController.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 3/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "HelloScene.h"
#import "SensiBot.h"
#import "RBL_BLE.h"

@interface ViewController ()

@end

@implementation ViewController
{
    RFduinoManager *bluetooth;
    UIViewController *reconnectScreen;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    HelloScene *hello = [[HelloScene alloc] initWithSize:CGSizeMake(768, 1024)];
    [hello setBleRadio:bluetooth from:reconnectScreen];
    SKView *spriteView = (SKView *) self.view;
    
    [spriteView presentScene: hello];
}

-(void) setBleRadio: (RFduinoManager *) value from:(UIViewController *) connectScreen
{
    bluetooth = value;
    reconnectScreen = connectScreen;
}

@end
