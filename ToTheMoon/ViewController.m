//
//  ViewController.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 3/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "HelloScene.h"

@interface ViewController ()

@end

@implementation ViewController
{
    RFduinoManager *bluetooth;
    RFduino *controller;
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
    [hello setBleRadio:bluetooth withController:controller from:reconnectScreen];
    SKView *spriteView = (SKView *) self.view;
    
    [spriteView presentScene: hello];
}

-(void) setBleRadio: (RFduinoManager *) value withController: (RFduino *) rfduino from:(UIViewController *) connectScreen;
{
    bluetooth = value;
    reconnectScreen = connectScreen;
    controller = rfduino;
}

@end
