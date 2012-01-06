//
//  LTLightStreak.h
//  LightstreakTest
//
//  Created by Maxime CHAPELET on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTLightStreak : SPSprite

@property (nonatomic, strong) NSMutableArray *parts;

- (id)init;
+ (id)streak;

- (id)initWithLength:(int)length;
+ (id)streakWithLength:(int)length;

@end
