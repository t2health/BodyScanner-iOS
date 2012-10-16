//
//  ViewBodyPartInfoController.h
//  iBreathe050
//
//  Created by Roger Reeder on 6/15/10.
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

@class ViewBodyScannerController;
@interface ViewBodyPartInfoController : UIViewController {
#pragma mark -
#pragma mark Main Layers
	UIView *vBackground;
	UIImageView *ivBoxB;
	UIImageView *ivBoxBL;
	UIImageView *ivBoxBR;
	UIImageView *ivBoxC;
	UIImageView *ivBoxCL;
	UIImageView *ivBoxML;
	UIImageView *ivBoxMR;
	UIImageView *ivBoxT;
	UIImageView *ivBoxTL;
	UIImageView *ivBoxTR;
	UIView *vDialog;
	UIImageView *ivTop;
	UIImageView *ivMiddle;
	UIImageView *ivBottom;
	UILabel *lblTitle;
	UIWebView *wvInfo;
	UIButton *bClose;
	NSString *sUrl;
	NSString *sTitle;
	UIImageView *ivShaderB;
	ViewBodyScannerController *parentController;

}
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) ViewBodyScannerController *parentController;
@property (nonatomic, retain) NSString *sURL;
@property (nonatomic, retain) NSString *sTitle;

-(int)MaxOfFontForLabel:(UILabel *)lbl andWidth:(CGFloat)width andHeight:(CGFloat)height;
- (void)initDisplay;
- (void)updateLayout:(CGRect)frame;
- (void)animClose;
- (void)animShow;
- (void)showInfo:(NSString *)titleOfPart filename:(NSString *)fileToLoad;
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;

@end
