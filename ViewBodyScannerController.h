//
//  ViewBodyScannerController.h
//  iBreathe
//
//  Created by Roger Reeder on 7/4/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//
/*
 *
 * BodyScanner
 *
 * Copyright © 2009-2012 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright © 2009-2012 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: BodyScanner001
 * Government Agency Original Software Title: BodyScanner
 * User Registration Requested. Please send email
 * with your contact information to: robert.kayl2@us.army.mil
 * Government Agency Point of Contact for Original Software: robert.kayl2@us.army.mil
 *
 */
#import <UIKit/UIKit.h>
#import "ViewBodyPartInfoController.h"
/** The ViewBodyScannerController class displays a human body with a scanner that highlights and identifies major organs.  It also describes how these parts of the body react under duress and stress.
 
 A typical calling sequence is as follows:
 
    // Allocate the controller
    ViewBodyScannerController *anotherController = [ViewBodyScannerController alloc];
    anotherController.view.alpha = 1.0;
 
    // Define the frame for the Body Scanner (adjust for iPhone, iPad, portrait. landscape, etc)
    CGRect r = self.view.frame;
    r.size.height = r.size.height - self.navigationController.navigationBar.frame.size.height;
 
    // Initialize the controller and apply the frame
    [anotherController initDisplay];
    [anotherController updateLayout:r];
    anotherController.title = @"Change the title";
 
    // This example uses a navigation controller
    [self.navigationController pushViewController:anotherController animated:YES];
 
    // Fade in the scanner, then start the scanner and finally initiate the scrolling of the body
    [anotherController fadeInView];
    [anotherController startScanner];
    [anotherController startScrolling];
    [anotherController release];
 
 (Note:  Some of the above refers to methods or properties of the UIViewController class.)
 */
typedef enum {
	enBrainButton = 0,
	enEyesButton,
	enEarsButton,
	enImmuneButton,
	enMusclesButton,
	enLungsButton,
	enHeartButton,
	enStomachButton,
	enFingersButton,
	enSkinButton,
} enBodyButton;

typedef enum {
	enBrainLoc = 0,
	enEyesLoc,
	enEarsLoc,
	enImmuneLoc,
	enMusclesTopLoc,
	enLungsLoc,
	enHeartLoc,
	enStomachLoc,
	enFingersLoc,
	enSkinLoc,
	enMusclesBottomLoc,
	enToesLoc,
} enBodyLocations;

@interface ViewBodyScannerController : UIViewController <UIScrollViewDelegate> {

	UIScrollView *scroller;
	UIImageView *ivBodyBack;
	UIImageView *ivScanLine;
	UIImageView *ivScanLineMask;
	
	NSTimer *timer;
	NSTimeInterval timeInterval;
	int scrollCounter;
	CGFloat animationInterval;
	
	BOOL bScroll;
	
    NSArray *ivParts;
	
	UIButton *bParts[10];
	UIImageView *ivInnerGlow[10];
	UIImageView *ivOuterGlow[10];
	UILabel *lblParts[10];
	NSArray *imageArray;
	
	ViewBodyPartInfoController *partInfo;
	
	CGFloat PixelsToScroll;

	CGPoint ScanOffset;
	BOOL bAutoScrolling;
	CGFloat partLocations[12][2];
	
	NSString *part;
	NSString *partTitle;

	CGFloat DEFAULTBODYASPECT;
    
    NSArray *parts;
}
@property(nonatomic, retain) NSArray *parts;
@property(nonatomic, retain) NSArray *ivParts;
@property (nonatomic, retain) UIScrollView *scroller;


-(CGFloat)getImageAspect:(UIImage *)img;

/** Update the Layout to conform to the available space

 This is specified as a CGRect.  It is used to define the available space for the Body Scanner.  This allows for customization for iPhone and iPad devices as well as landscape and portrait orientations.  Also you can make allowances for other titles, labels or status bars.
 
 @param frame  The frame (CGRect) that defines the area available to the Body Scanner
 */
- (void)updateLayout:(CGRect)frame;

/** Initialize the Display 
 
 Load and configure the Body Scanner assets.
 
 */
- (void)initDisplay;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;

/** Fade OUT the View 
 
 Fade the body scanner from being visible over a period of 1 second.
 
 */
- (void)fadeOutView;

/** Fade IN the View 
 
 Make the body scanner view visible over a period of 1 second.
 
 */
- (void)fadeInView;
- (void)animShowView;

- (void)loadButtons;
- (void)partsButton_TouchDown:(id)sender;


/** Start the Body Scanner 
 
 Start the Body Scanner
 
 */
- (void)startScanner;

- (void)scroll:(NSTimer *)theTimer;

/** Scart Scrolling 
 
 Scroll the Body Scanner
 
 */
- (void)startScrolling;

@end
