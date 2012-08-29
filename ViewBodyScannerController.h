//
//  ViewBodyScannerController.h
//  iBreathe
//
//  Created by Roger Reeder on 7/4/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewBodyPartInfoController.h"

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
- (void)updateLayout:(CGRect)frame;
- (void)initDisplay;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutView;
- (void)fadeInView;
- (void)animShowView;

- (void)loadButtons;
- (void)partsButton_TouchDown:(id)sender;
- (void)startScanner;

- (void)scroll:(NSTimer *)theTimer;
- (void)startScrolling;

@end
