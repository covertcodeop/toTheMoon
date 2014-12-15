//
//  ConnectViewController.h
//  ToTheMoon
//
//  Created by Zenko Klapko on 7/9/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFduino.h"
#import "RFduinoManager.h"

@interface ConnectViewController : UIViewController <RFduinoManagerDelegate, RFduinoDelegate>
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end
