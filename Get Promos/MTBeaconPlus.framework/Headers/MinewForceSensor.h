//
//  MinewForceSensor.h
//  MTBeaconPlus
//
//  Created by SACRELEE on 10/30/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewForceSensor: MinewFrame

@property (nonatomic, strong) NSString *mac;

@property (nonatomic, assign) NSInteger battery;

@property (nonatomic, assign) NSInteger gramValue;

@end
