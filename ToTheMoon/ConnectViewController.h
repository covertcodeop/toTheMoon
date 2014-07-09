//
//  ConnectViewController.h
//  ToTheMoon
//
//  Created by Zenko Klapko on 7/9/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBL_BLE_Delegate.h"

@interface ConnectViewController : UIViewController <RBL_BLE_Delegate>
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end
