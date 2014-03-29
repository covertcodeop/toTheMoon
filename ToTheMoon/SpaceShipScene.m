//
//  SpaceShipScene.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 3/29/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import "SpaceShipScene.h"

@implementation SpaceShipScene

-(void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        self.contentCreated = YES;
    }
}

-(void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
}
@end
