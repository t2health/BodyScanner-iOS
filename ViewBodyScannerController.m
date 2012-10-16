    //
//  viewBodyScannerController.m
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
#import "ViewBodyScannerController.h"
#import "ViewBodyPartInfoController.h"

const CGFloat kPartCenter = 0.0f;
const CGFloat kPartFade = 1.0f;
const CGFloat kDEFAULTBODYWIDTH = 480.0f;
const CGFloat kScannerAspect = (25.0f/1057.0f);
const CGFloat kScannerx = 1057.0f;
const CGFloat kLabelAspect = (100.0f/57.0f);

@implementation ViewBodyScannerController
@synthesize scroller;
@synthesize parts;
@synthesize ivParts;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	PixelsToScroll = 1.0f;
	CGRect rect = [[UIScreen mainScreen] bounds];
	UIView *v = [[UIView alloc] initWithFrame:rect];
	v.backgroundColor = [UIColor blackColor];
	self.view = v;
	[v release];
	[super viewDidLoad];
}

- (void)initDisplay	{
    NSMutableArray *imageviewParts = [[NSMutableArray alloc] init];
    
    // Find the Library Resouce bundle in the Main Bundle
    NSBundle *staticBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"BodyScannerResources.bundle"]];
    
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[staticBundle pathForResource:@"bodyscanner" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil errorDescription:nil];

    parts = [[NSArray arrayWithArray:[ps objectForKey:@"bodyParts"]] retain];

	bAutoScrolling = NO;
	CGSize hpSize;
	hpSize.width = 480.0f;
	hpSize.height = 292.0f;
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 292)];
	self.view.backgroundColor = [UIColor blackColor];
	
	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 292)];
	sv.backgroundColor = [UIColor blackColor];
	sv.alpha = 1.0f;
	sv.showsVerticalScrollIndicator = NO;
	sv.showsHorizontalScrollIndicator = NO;
	UIEdgeInsets inset;
	inset.left = 0.0f;
	inset.right = 0.0f;
	inset.top = [sv frame].size.height * 0.375f;
	inset.bottom = [sv frame].size.height * 0.375f;
	[sv setContentInset:inset];
	
	[sv setContentSize:CGSizeMake(480, 825)];
	[sv setContentOffset:CGPointMake(480.0/2.0 - 480.0/2.0, 0.0)];
	[v addSubview:sv];
	self.view = v;
	scroller = sv;
	scroller.delegate = self;
	
	//  Add Background Body Layer
    NSDictionary *bodyInfo = (NSDictionary *)[ps objectForKey:@"body"];
    NSString *bodyBundleName = [bodyInfo objectForKey:@"bundleName"];
	UIImageView *iv = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, 480, 825)];
	[iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:bodyBundleName ofType:@"png"]]];
    DEFAULTBODYASPECT = [self getImageAspect:iv.image];
	[scroller addSubview:iv];
	ivBodyBack = iv;
	[iv release];
	

	// Add Scanner Layer
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 146.0f - 14.0f, 480.0f, 27.0f)];
	[scroller addSubview:iv];
	
    NSDictionary *scannerInfo = (NSDictionary *)[ps objectForKey:@"scanner"];
    int scannerCount = [[scannerInfo objectForKey:@"imageCount"] intValue];
    NSString *scannerBundleName = [scannerInfo objectForKey:@"bundleName"];
    NSMutableArray *maImg = [[[NSMutableArray alloc] init] autorelease];
	// Loads all images into one array
    for (int i = 0; i < scannerCount ; i++ ) {
        NSString *imageName = [NSString stringWithFormat:@"%@%i",scannerBundleName,i];
        [maImg addObject:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:imageName ofType:@"png"]]];
    }
	imageArray  = [NSArray arrayWithArray:maImg];
    
	iv.animationImages = imageArray;
	iv.animationDuration = 5.0f * 1.0f/30.0f; // Animation lasts 19.2 seconds
	iv.animationRepeatCount = 0; // Repeats indefinately
	iv.contentMode = UIViewContentModeScaleToFill; 
	ivScanLine = iv;
	ScanOffset = ivScanLine.center;
	[iv release];
	
	// Add Scanner Mask
    NSDictionary *scannerMask = (NSDictionary *)[ps objectForKey:@"scanLineMask"];
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 825)];
	[iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:[scannerMask objectForKey:@"bundleName"] ofType:@"png"]]]; 
	[scroller addSubview:iv];
	ivScanLineMask = iv;
	[iv release];
	
    BOOL overBody = NO;
    for (NSDictionary *eachPart in parts ) {
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 825)];
        [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:[eachPart objectForKey:@"bundleName"] ofType:@"png"]]];
        iv.alpha = 0.0f;
        overBody = [[eachPart objectForKey:@"overBody"] boolValue];
        [imageviewParts addObject:iv];
        if (overBody) {
            [scroller addSubview:iv];
        } else {
            [scroller insertSubview:iv belowSubview:ivScanLine];
        }
        [iv release];
    }
    ivParts = [[NSArray arrayWithArray:imageviewParts] retain];
	[imageviewParts release];
	
	[sv release];
	[scroller setContentOffset:CGPointMake(0.0f, scroller.contentSize.height * 0.001f)];
	[self loadButtons];
	
	partInfo = [[ViewBodyPartInfoController alloc] retain];
	partInfo.parentController = self;
	[self.view addSubview:partInfo.view];

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[timer invalidate];
	[scroller release];
	[ivBodyBack release];
	[ivScanLine release];
	[ivScanLineMask release];
	
	[partInfo release] ;
	[imageArray release];
	[imageArray release];
	
    [super dealloc];
}

- (void)updateLayout:(CGRect)frame {
	[self.view setFrame:frame];
	[scroller setFrame:frame];
	CGFloat aspectRatio;
	CGSize newSize;
	if (frame.size.width > frame.size.height) { //landscape
		newSize = CGSizeMake(frame.size.width, frame.size.width * DEFAULTBODYASPECT);
	}else {
		newSize = CGSizeMake(frame.size.width * 1.5f, (frame.size.width * 1.5f) * DEFAULTBODYASPECT);
	}
	aspectRatio = newSize.width / kDEFAULTBODYWIDTH;
    
	[scroller setContentSize:newSize];
	UIEdgeInsets inset;
	if (frame.size.width > frame.size.height) { //landscape
		inset.left = 0.0f;
	}else {
		inset.left = - frame.size.width * 0.5f;
	}
	inset.right = 0.0f;
	inset.top = frame.size.height * 0.46f;
	inset.bottom = frame.size.height * 0.46f;
	[scroller setContentInset:inset];
	
	[ivBodyBack setFrame:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	[ivScanLineMask setFrame:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	
	CGFloat x,y,w,h;
    
    
    // Find the Library Resouce bundle in the Main Bundle
    NSBundle *staticBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"BodyScannerResources.bundle"]];

	w = kScannerx * aspectRatio;
    
    h = w * [self getImageAspect:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"ibreathe_body_scan0" ofType:@"png"]]];
	x = newSize.width/2.0 - w * 0.5f;
	y = self.view.frame.size.height/2.0f - h * 0.5f;
	[ivScanLine setFrame:CGRectMake(x, y, w, h)];
	ScanOffset = ivScanLine.center;
	
    for (int partCount = 0; partCount < [ivParts count]; partCount++) {
        NSDictionary *thisPart = (NSDictionary *)[parts objectAtIndex:partCount];
        UIImageView *iv = (UIImageView *)[ivParts objectAtIndex:partCount];
        CGFloat partX = [(NSNumber *)[thisPart objectForKey:@"x"] floatValue];
        CGFloat partY = [(NSNumber *)[thisPart objectForKey:@"y"] floatValue];
        if ([[thisPart objectForKey:@"overBody"] boolValue]) {
            w = kDEFAULTBODYWIDTH * aspectRatio;
            h = w * DEFAULTBODYASPECT;
        } else {
            w = partX * aspectRatio;
            h = w * [self getImageAspect:iv.image];
        }
        x = newSize.width/2.0 - w * 0.5f;
        y = newSize.height * partY - h * 0.5f;
        [iv setFrame:CGRectMake(x, y, w, h)];
    }
	
	//update button layout...
	//buttons
	int i;
	CGFloat bMargin = 10.0f;
	if (frame.size.width > frame.size.height) { //landscape
		h = self.view.frame.size.height/5.0f;
	}else {
		h = self.view.frame.size.height/10.0f;
	}
	
	w = h;
	for (i=0; i<10; i++) {
		if (frame.size.width > frame.size.height) { //landscape
			x = (i % 2 == 0) ? 0.0f + bMargin : self.view.frame.size.width - w - bMargin;
			y = (i/2) * h;
		}else {
			x = self.view.frame.size.width - w - bMargin;
			y = i * h;
		}
		[bParts[i] setFrame:CGRectMake(x, y, w, h)];
		[ivInnerGlow[i] setFrame:CGRectMake(x, y, w, h)];
		[ivOuterGlow[i] setFrame:CGRectMake(x, y, w, h)];
	}
	
	//Labels
	for (i=0; i<10; i++) {
		if (frame.size.width > frame.size.height) { //landscape
			w = h * kLabelAspect;
			x = (i % 2 == 0) ? 0.0f + bMargin + h : self.view.frame.size.width - w - h - bMargin * 2.0f;
			lblParts[i].textAlignment = (i % 2 == 0) ? UITextAlignmentLeft : UITextAlignmentRight;
			y = (i/2) * h;
			[lblParts[i] setFont:[lblParts[i].font fontWithSize:h * 0.33f]];
		}else {
			w = h * kLabelAspect * 3.0f;
			lblParts[i].textAlignment = UITextAlignmentRight;
			x = self.view.frame.size.width - w - h - bMargin;
			y = i * h;
			[lblParts[i] setFont:[lblParts[i].font fontWithSize:h * 0.5f]];
		}
		[lblParts[i] setFrame:CGRectMake(x, y, w, h)];
	}
	if (frame.size.width > frame.size.height) { //landscape
		[scroller setContentOffset:CGPointMake(0.0f, newSize.height * 0.027f - frame.size.height * 0.50f)];
		h = self.view.frame.size.height/5.0f;
		x = bMargin * 2.0f + h;
		w = frame.size.width - (x + bMargin) * 2.0f;
		y = bMargin;
		h = frame.size.height - y * 2.0f;
	}else {
		[scroller setContentOffset:CGPointMake(frame.size.width * 0.5f, newSize.height * 0.027f - frame.size.height * 0.50f)];
		h = self.view.frame.size.height/10.0f;
		x = bMargin;
		w = frame.size.width - bMargin * 3.0f - h ;
		y = bMargin;
		h = frame.size.height - y * 2.0f;
	}
	[partInfo updateLayout:CGRectMake(x, y, w, h)];

}


- (void)loadButtons{
	UIButton *b;
	UIImageView *iv;
	NSString *iconName;
    
    
    // Find the Library Resouce bundle in the Main Bundle
    NSBundle *staticBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"BodyScannerResources.bundle"]];
    
    NSString *innerGlowName = [staticBundle pathForResource:@"bglow2" ofType:@"png"];
    NSString *outerGlowName = [staticBundle pathForResource:@"bouterglow" ofType:@"png"];
	CGFloat bx, by;
	
	CGFloat bWidth = 57.0f;
	CGFloat bHeight = 57.0f;
	CGFloat bGlowPadding = 15.0f;
	CGFloat bMargin = 10.0f;
	CGFloat lblWidth = 100.0f;
	UILabel *lbl;
	UIFont *flbl = [UIFont fontWithName:@"Helvetica" size:bHeight * 0.33f];
	
    
	// Outer glow of buttons
    int partCount;
    for (partCount = 0; partCount < [parts count]; partCount++) {
        NSDictionary *thisPart = (NSDictionary *)[parts objectAtIndex:partCount];
		bx = (partCount % 2 == 0) ? 0.0f + bMargin : self.view.frame.size.width - bWidth - bMargin;
		by = (partCount/2) * bHeight;
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(bx - bGlowPadding, by - bGlowPadding, bWidth + 2.0f * bGlowPadding, bHeight + 2.0f * bGlowPadding)];
        [iv setImage:[UIImage imageWithContentsOfFile:outerGlowName]];
		iv.alpha = 0.0f;
		[self.view addSubview:iv];
		ivOuterGlow[partCount] = iv;
		[iv release];
		
		//Inner Glow ImageView
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(bx, by, bWidth, bHeight)];
        [iv setImage:[UIImage imageWithContentsOfFile:innerGlowName]];
		iv.alpha = 0.0f;
		ivInnerGlow[partCount] = iv;
		[self.view addSubview:iv];
		[iv release];

		bx = (partCount % 2 == 0) ? 0.0f + bMargin + bWidth + bMargin : self.view.frame.size.width - bWidth - bMargin * 2.0f - lblWidth;
		by = (partCount/2) * bHeight;
        iconName = [thisPart objectForKey:@"buttonTitle"];
    
		lbl = [[UILabel new] initWithFrame:CGRectMake( bx, by, lblWidth, bHeight)];
		lbl.lineBreakMode = UILineBreakModeWordWrap;
		lbl.numberOfLines =2;
		lbl.font = flbl;
		[lbl setTextAlignment:(partCount % 2 == 0) ? UITextAlignmentLeft : UITextAlignmentRight];
		[lbl setLineBreakMode:UILineBreakModeClip];
		lbl.text = iconName;
		[lbl setTextColor:[UIColor whiteColor]];
		[lbl setShadowColor:[UIColor blackColor]];
		[lbl setShadowOffset:CGSizeMake(1.0f, 1.0f)];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setAlpha:0.5f];
		[self.view addSubview:lbl];
		lblParts[partCount] = lbl;
		[lbl release];

		bx = (partCount % 2 == 0) ? 0.0f + bMargin : self.view.frame.size.width - bWidth - bMargin;
		by = (partCount/2) * bHeight;
        iconName = [thisPart objectForKey:@"buttonImage"];
        iconName = [staticBundle pathForResource:iconName ofType:@"png"];   // Get the path
                
		b = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[b setBackgroundImage:[UIImage imageWithContentsOfFile:iconName]  forState:UIControlStateNormal];
		[b setFrame:CGRectMake(bx,by, bWidth, bHeight)];
        
		b.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[b setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
		[b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[b setTitleShadowColor:[UIColor grayColor] forState:UIControlStateHighlighted];
		[b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[b setTitleShadowColor:[UIColor grayColor] forState:UIControlStateSelected];
		b.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		b.tag = partCount;
		[b addTarget:self action:@selector(partsButton_TouchDown:) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:b];
		bParts[partCount] = b;
		[b release];
    }
}
- (void)partsButton_TouchDown:(id)sender {
	UIButton *b = (UIButton*)sender;
	CGFloat newPosition = -1.0f;
	CGFloat increment = scroller.contentSize.height / 100.0f;

	CGPoint p = scroller.contentOffset;
	CGFloat scanPoint =	(p.y + scroller.frame.size.height/2.0f) / scroller.contentSize.height * 100.0f;  // scanning point 0 to 100;
	
    NSDictionary *partItem = (NSDictionary *)[parts objectAtIndex:b.tag] ;
    part = [partItem objectForKey:@"title"];
    partTitle = [partItem objectForKey:@"buttonTitle"];
    NSArray *locations = (NSArray *)[partItem objectForKey:@"locations"];
    CGFloat thisPos = 0.0f;
    for (int i = 0; i < [locations count]; i++) {
        thisPos = [(NSNumber *)[(NSDictionary *)[locations objectAtIndex:i] objectForKey:@"top"] floatValue];
        if (newPosition < 0.0f || fabs(scanPoint - thisPos) < fabs(scanPoint - newPosition)) {
            newPosition = thisPos;
        }
    }
 	bAutoScrolling = NO;
	[scroller setContentOffset:CGPointMake(scroller.contentOffset.x, increment * newPosition - (scroller.frame.size.height/2.0f)) animated:YES];
	[partInfo showInfo:partTitle filename:part];

}


#pragma mark -
#pragma mark Scroller Funtions
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	bAutoScrolling = NO;
	[self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGPoint p = scrollView.contentOffset;
	CGPoint tp = scrollView.contentOffset;
	CGFloat scanPoint = (p.y + scrollView.frame.size.height/2.0f) / scrollView.contentSize.height * 100.0f;  // scanning point 0 to 100;
	tp.x = ScanOffset.x + p.x;
	tp.y = ScanOffset.y + p.y;
	[ivScanLine setCenter:tp];
	CGFloat fAlpha = 0.0f;
    CGFloat newPoint = -1.0f;
    CGFloat thisPoint = 0.0f;
    NSDictionary *thisPart;
    CGFloat partHeight = 0.0f;
	if (bAutoScrolling==NO) {
        for (int i = 0; i < [parts count]; i++) {
            thisPart = [parts objectAtIndex:i];
            newPoint = -1.0f;
            NSArray *locations  = [thisPart objectForKey:@"locations"];
            for (NSDictionary *location in locations){
                thisPoint = [(NSNumber *)[location objectForKey:@"top"] floatValue];
                if (newPoint < 0.0f || fabs(scanPoint - thisPoint) < fabs(scanPoint - newPoint)) {
                    newPoint = thisPoint;
                    partHeight = [(NSNumber *)[location objectForKey:@"height"] floatValue];
                }
            }
            fAlpha = 0.0f;
            if (scanPoint > newPoint - partHeight && scanPoint < newPoint + partHeight) {
                fAlpha = (partHeight - fabs(scanPoint - newPoint))/partHeight;
            }
			UIImageView *iv = [ivParts objectAtIndex:i];
			iv.alpha = fAlpha;
			//ivInnerGlow[i].alpha = fAlpha;
            ivOuterGlow[i].alpha = fAlpha;
			lblParts[i].alpha = 0.5f + fAlpha * 0.5f;
		}
	}
}

-(void)startScrolling {
	const CGFloat kFramesPerSecond =	30.0f;
	// Start scrolling text
	scrollCounter = 0;
	bScroll = NO;
	animationInterval = 1.0f/kFramesPerSecond;
	timer =	[NSTimer scheduledTimerWithTimeInterval:animationInterval
											 target:self
										   selector:@selector(scroll:)
										   userInfo:nil
											repeats:YES];
	
}

-(void)scroll:(NSTimer *)theTimer {

	scrollCounter++;
	CGPoint old = [scroller contentOffset];
	if ((CGFloat)scrollCounter * animationInterval > 2.0f) {  //However many seconds to wait before scrolling.
		bScroll = YES;
	}
	if ( !bScroll || !partInfo.view.hidden) {
		return;
	}
	if (old.y + scroller.frame.size.height >= scroller.contentSize.height + scroller.contentInset.bottom || old.y < scroller.contentInset.top * -1.0f) {
		PixelsToScroll = PixelsToScroll * -1.0f;
	}
	[scroller setContentOffset:CGPointMake(scroller.contentOffset.x, old.y + PixelsToScroll) animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	scrollCounter = 0;
	if (bScroll) {
		bScroll = NO;
	}
}


#pragma mark Utilities


- (CGFloat)getImageAspect:(UIImage *)img {
	CGFloat h = img.size.height;
	CGFloat w = img.size.width;
    
	return h/w; 
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if (animationID == @"animPartClose"/* && finished*/) {
		scrollCounter = 0;
		if (bScroll) {
			bScroll = NO;
		}
		partInfo.view.hidden = YES;
		NSString *tempUrl = partInfo.sURL;
		if (![tempUrl isEqualToString:@""] && ![partInfo.lblTitle.text isEqualToString:partTitle]) {
			[partInfo showInfo:partTitle filename:part];
		}
	}
}	

- (void)fadeOutView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutView" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)animShowView {		//Animate Fade Out
	[UIView beginAnimations:@"animShowView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	[UIView commitAnimations];
}

- (void)startScanner {
	[ivScanLine startAnimating];
}
@end
