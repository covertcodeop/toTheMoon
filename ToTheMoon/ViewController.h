//
//  ViewController.h
//  ToTheMoon
//
//  Created by Zenko Klapko on 3/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "RBL_BLE.h"

@interface ViewController : UIViewController

-(void) setBleRadio: (RBL_BLE *) value forDevice: (NSUUID *) identifier from:(UIViewController *) connectScreen;

@end
