//
//  LTViewController.m
//  LightstreakTest
//
//  Created by Maxime CHAPELET on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "LTAppDelegate.h"
#import "LTViewController.h"
#import "LTLightStreak.h"

@implementation LTViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
	[self shouldAutorotateToInterfaceOrientation:[self interfaceOrientation]];
	LTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	SPView *sparrowView = [[SPView alloc] initWithFrame:[appDelegate applicationFrame]];
	[sparrowView setFrameRate:60.0f];
	SPStage *mainStage = [[SPStage alloc] initWithWidth:[appDelegate applicationWidth] height:[appDelegate applicationHeight]];
	[mainStage setColor:0xFF0000];
	SPQuad *background = [SPQuad quadWithWidth:[appDelegate applicationWidth] height:[appDelegate applicationHeight] color:0x000000];
	[mainStage addChild:background];
	LTLightStreak *lightStreak = [LTLightStreak streak];
	[mainStage addChild:lightStreak];
	[sparrowView setStage:mainStage];
	[sparrowView start];
	[mainStage release];
	[[self view] addSubview:sparrowView];
	[sparrowView release];
	NSLog(@"Width:%f Height:%f",
		  [appDelegate applicationWidth],
		  [appDelegate applicationHeight]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	CGRect screenFrame = [[UIScreen mainScreen] bounds];
	LTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
		[appDelegate setApplicationWidth:screenFrame.size.height];
		[appDelegate setApplicationHeight:screenFrame.size.width];
	} else {
		[appDelegate setApplicationWidth:screenFrame.size.width];
		[appDelegate setApplicationHeight:screenFrame.size.height];
	}
	CGRect applicationFrame = CGRectMake(0, 0, [appDelegate applicationWidth], [appDelegate applicationHeight]);
	[appDelegate setApplicationFrame:applicationFrame];
//	NSLog(@"Width:%f Height:%f", \
		  [appDelegate applicationWidth], \
		  [appDelegate applicationHeight]);
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
