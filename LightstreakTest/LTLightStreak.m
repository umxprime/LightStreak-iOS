//
//  LTLightStreak.m
//  LightstreakTest
//
//  Created by Maxime CHAPELET on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LTLightStreak.h"

@interface LTLightStreakPart : SPSprite

@property (nonatomic, strong) SPPoint *begin;
@property (nonatomic, strong) SPPoint *end;
@property (nonatomic) float radius;
@property (nonatomic, strong) LTLightStreak *streak;
@property (nonatomic) int index;

- (id)initWithStreak:(LTLightStreak *)streak;
+ (id)partWithStreak:(LTLightStreak *)streak;

@end

@interface LTLightStreakPart ()
- (void)onAddedToStage:(SPEvent *)event;
- (void)onEnterFrame:(SPEnterFrameEvent *)event;
@end

@implementation LTLightStreakPart

@synthesize begin = _begin;
@synthesize end = _end;
@synthesize radius = _radius;
@synthesize streak = _streak;
@synthesize index = _index;

- (id)initWithStreak:(LTLightStreak *)streak
{
	self = [super init];
	if (self)
	{
		[self setStreak:streak];
		_begin = [[SPPoint alloc] initWithX:0.0f y:0.0f];
		_end = [[SPPoint alloc] initWithX:0.0f y:0.0f];
		[self addEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	}
	return self;
}

+ (id)partWithStreak:(LTLightStreak *)streak
{
	return [[[self alloc] initWithStreak:streak] autorelease];
}

- (void)onAddedToStage:(SPEvent *)event
{
	[self removeEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	
	[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
	for(int i = 0; i <5 ; i++)
	{
		double smoothness = 0.8;
		_begin.x = _end.x * smoothness + _begin.x * (1.0 - smoothness);
		_begin.y = _end.y * smoothness + _begin.y * (1.0 - smoothness);
		
		NSArray *parts = [_streak parts];
		int size = [parts count];
		if (_index < size - 1)
		{
			LTLightStreakPart *nextPart = [parts objectAtIndex:(_index + 1)];
			[_end setX:[[nextPart begin] x]];
			[_end setY:[[nextPart begin] y]];
		}
	}
	
	[self removeAllChildren];
	SPQuad *beginQuad = [SPQuad quadWithWidth:5 height:5];
	beginQuad.x = _begin.x;
	beginQuad.y = _begin.y;
	[self addChild:beginQuad];
	SPQuad *endQuad = [SPQuad quadWithWidth:5 height:5];
	endQuad.x = _end.x;
	endQuad.y = _end.y;
	[self addChild:endQuad];
}

- (void)dealloc
{
	[_streak release];
	[_begin release];
	[_end release];
	[super dealloc];
}

@end

/*
 LightStreak
 */

@interface LTLightStreak ()
- (void)onAddedToStage:(SPEvent *)event;
- (void)onTouch:(SPTouchEvent *)touchEvent;
@end

@implementation LTLightStreak

@synthesize parts = _parts;

- (id)init
{
	return [self initWithLength:20];
}

+ (id)streak
{
	return [[[self alloc] init] autorelease];
}

- (id)initWithLength:(int)length
{
	self = [super init];
	if(self)
	{
		_parts = [[NSMutableArray alloc] initWithCapacity:length];
		
		for (int i = 0; i < length; i ++) {
			LTLightStreakPart *part = [LTLightStreakPart partWithStreak:self];
			[part setIndex:i];
			[_parts addObject:part];
			[self addChild:part];
		}
		
		[self addEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	}
	return self;
}

+ (id)streakWithLength:(int)length
{
	return [[[self alloc] initWithLength:length] autorelease];
}

- (void)onAddedToStage:(SPEvent *)event
{
	[self removeEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	
	[[self stage] addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH retainObject:YES];
}

- (void)onTouch:(SPTouchEvent *)touchEvent
{
	SPTouch *touch = [[touchEvent touches] anyObject];
	LTLightStreakPart *lastPart = [_parts lastObject];
	SPPoint *touchLocation = [touch locationInSpace:self];
	[[lastPart end] setX:[touchLocation x]];
	[[lastPart end] setY:[touchLocation y]];
	if([touch phase] == SPTouchPhaseBegan)
	{
		for (LTLightStreakPart *part in _parts) {
			[[part begin] setX:[touchLocation x]];
			[[part begin] setY:[touchLocation y]];
			[[part end] setX:[touchLocation x]];
			[[part end] setY:[touchLocation y]];
		}
	}
}

- (void)dealloc
{
	[_parts release];
	[super dealloc];
}

@end
