//
//  ViewBodyPartInfoController.m
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
#import "ViewBodyPartInfoController.h"
#import "ViewBodyScannerController.h"

@implementation ViewBodyPartInfoController

//TODO: is there any way to calculate these values?
const CGFloat InfoBoxBHeight = 27.0f;
const CGFloat InfoBoxBLWidth = 27.0f;
const CGFloat InfoBoxBRWidth = 27.0f;
const CGFloat InfoBoxCLWidth = 11.0f;
const CGFloat InfoBoxMLWidth = 16.0f;
const CGFloat InfoBoxMRWidth = 20.0f;
const CGFloat InfoBoxTHeight = 27.0f;
const CGFloat InfoBoxTLWidth = 27.0f;
const CGFloat InfoBoxTRWidth = 27.0f;

@synthesize parentController, lblTitle, sURL, sTitle;
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGFloat x,y,w,h;
	
	//TODO: More hardcoded numbers, are they really necessary?
	// Can we calculate or store externally?
	x = 88.0f;
	y = 33.0f;
	w = 304.0f;
	h = 248.0f;
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x,y,w,h)];
	v.backgroundColor = [UIColor clearColor];
	self.view = v;
	[v release];
	[self initDisplay];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
    [super dealloc];
}

#pragma mark -
#pragma mark Layout Funtions
- (void)initDisplay {
	CGFloat x,y,w,h;
	CGFloat bHeight, bWidth, bPadding, lblHeight;
	CGRect r = self.view.frame;
//TODO: Externalize or calculate?
	bHeight =  35.0f;
	lblHeight = bHeight;
	//This should be calculated via the UIUserInterfaceIdiom
	if (r.size.width > 480.0f || r.size.height > 480.0f) {
		lblHeight = 50.0f;
	}
	bWidth = 35.0f;
	bPadding = 10.0f;
	
	//TODO: this feels like it would be better done in a loop?
    // Find the Library Resouce bundle in the Main Bundle
    NSBundle *staticBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"BodyScannerResources.bundle"]];
	
	x = 0.0f;
	y = 0.0f;
	w = InfoBoxTLWidth;
	h = InfoBoxTLWidth;
	UIImageView *iv = [[UIImageView alloc]  initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxTL.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxTL" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxTL = iv;
	[iv release];

	x = x + w;
	w = r.size.width - InfoBoxTLWidth - InfoBoxTRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxT.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxT" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxT = iv;
	[iv release];
	
	x = x + w;
	w = InfoBoxTRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxTR.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxTR" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxTR = iv;
	[iv release];
	
	
	x = 0.0f;
	y = InfoBoxTLWidth;
	w = InfoBoxMLWidth;
	h = r.size.height - InfoBoxTLWidth - InfoBoxBLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxML.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxML" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxML = iv;
	[iv release];

	x = x + w;
	w = InfoBoxCLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxCL.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxCL" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxCL	= iv;
	[iv release];
	
	
	x = x + w;
	w = r.size.width - InfoBoxMLWidth - InfoBoxMRWidth - InfoBoxCLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxC.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxC" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxC= iv;
	[iv release];
	
	x = x + w;
	w = InfoBoxMRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxMR.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxMR" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxMR	= iv;
	[iv release];
	
	x = 0.0f;
	y = y + h;
	w = InfoBoxBLWidth;
	h = InfoBoxBLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxBL.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxBL" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxBL = iv;
	[iv release];
	
	x = x + w;
	w = r.size.width - InfoBoxBLWidth - InfoBoxBRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxB.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxB" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxB = iv;
	[iv release];
	
	x = x + w;
	w = InfoBoxBRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	//[iv setImage:[UIImage imageNamed:@"InfoBoxBR.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"InfoBoxBR" ofType:@"png"]]];
	[self.view addSubview:iv];
	ivBoxBR = iv;
	[iv release];
	
	x = InfoBoxMLWidth;
	y = InfoBoxTLWidth;
	w = r.size.width - InfoBoxMLWidth - InfoBoxMRWidth;
	h = r.size.height - InfoBoxTLWidth - InfoBoxBLWidth;
	UIView *innerV = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	innerV.backgroundColor = [UIColor clearColor];
	[self.view addSubview:innerV];
	
	
	UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	//[b setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bclose.png"]]  forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"bclose" ofType:@"png"]] forState:UIControlStateNormal];
	
	[b setFrame:CGRectMake(innerV.frame.size.width - bWidth, 0.0f, bWidth, bHeight)];
	[b addTarget:self action:@selector(closeButton_TouchDown:) forControlEvents:UIControlEventTouchDown];
	[innerV addSubview:b];
	bClose = b;
	[b release];
	b.userInteractionEnabled = NO;
	
	UIFont *flblTitle =	[UIFont fontWithName:@"Helvetica" size:22.0f];
	
	UILabel *lbl = [[UILabel new] initWithFrame:CGRectMake(bPadding, bPadding, r.size.width - (bPadding * 2.0f), lblHeight)];
	lbl.numberOfLines = 1;
	lbl.font = flblTitle;
	[lbl setTextAlignment:UITextAlignmentLeft];
	[lbl setLineBreakMode:UILineBreakModeClip];
	lbl.text = @"Title";
	[lbl setTextColor:[UIColor whiteColor]];
	[lbl setShadowColor:[UIColor blackColor]];
	[lbl setShadowOffset:CGSizeMake(1.0f, 1.0f)];
	[lbl setBackgroundColor:[UIColor clearColor]];
	[lbl setAlpha:1.0f];
	[innerV addSubview:lbl];
	lblTitle = lbl;
	[lbl release];
	
	r = innerV.frame;
	UIWebView *web = [[UIWebView alloc] initWithFrame:r];
	[web setBackgroundColor:[UIColor clearColor]];
	[web setOpaque:NO];
	wvInfo = web;
	[innerV addSubview:wvInfo];
	[web release];
	
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, r.size.height - 50.0f, r.size.width, 50.0f)];
	//[iv setImage:[UIImage imageNamed:@"bottomshader.png"]];
    [iv setImage:[UIImage imageWithContentsOfFile:[staticBundle pathForResource:@"bottomshader" ofType:@"png"]]];
	[innerV addSubview:iv];
	ivShaderB = iv;
	[iv release];
	
	self.view.hidden = YES;
	[self.view addSubview:innerV];
	vDialog = innerV;
	[innerV release];
}

- (void)updateLayout:(CGRect)frame {
	[self.view setFrame:frame];
	CGFloat x,y,w,h;
	CGFloat bHeight, bWidth, bPadding, lblHeight;
	bHeight =  35.0f;
	lblHeight = bHeight;
	if (frame.size.width > 480.0f || frame.size.height > 480.0f) {
		lblHeight = 70.0f;
	}
	bWidth = 35.0f;
	bPadding = 10.0f;
	
	x = InfoBoxMLWidth;
	y = InfoBoxTLWidth;
	w = frame.size.width - InfoBoxMLWidth - InfoBoxMRWidth;
	h = frame.size.height - InfoBoxTLWidth - InfoBoxBLWidth;
	[vDialog setFrame:CGRectMake(x, y, w, h)];
	
	x = 0.0f;
	y = 0.0f;
	w = InfoBoxTLWidth;
	h = InfoBoxTLWidth;
	[ivBoxTL setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = frame.size.width - InfoBoxTLWidth - InfoBoxTRWidth;
	[ivBoxT setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = InfoBoxTRWidth;
	[ivBoxTR setFrame:CGRectMake(x, y, w, h)];
	
	
	x = 0.0f;
	y = InfoBoxTLWidth;
	w = InfoBoxMLWidth;
	h = frame.size.height - InfoBoxTLWidth - InfoBoxBLWidth;
	[ivBoxML setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = InfoBoxCLWidth;
	[ivBoxCL setFrame:CGRectMake(x, y, w, h)];
	
	
	x = x + w;
	w = frame.size.width - InfoBoxMLWidth - InfoBoxMRWidth - InfoBoxCLWidth;
	[ivBoxC setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = InfoBoxMRWidth;
	[ivBoxMR setFrame:CGRectMake(x, y, w, h)];
	
	x = 0.0f;
	y = y + h;
	w = InfoBoxBLWidth;
	h = InfoBoxBLWidth;
	[ivBoxBL setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = frame.size.width - InfoBoxBLWidth - InfoBoxBRWidth;
	[ivBoxB setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = InfoBoxBRWidth;
	[ivBoxBR setFrame:CGRectMake(x, y, w, h)];
	
	x = vDialog.frame.size.width - bWidth;
	y = 0.0f;
	[bClose setFrame:CGRectMake(x, y, bWidth, bHeight)];

	x = bPadding;
	y = bPadding;
	w = vDialog.frame.size.width - bPadding * 2.0f - bWidth;
	h = lblHeight;
	[lblTitle setFrame:CGRectMake(x, y, w, h)];

	x = bPadding;
	y = bPadding + lblHeight;
	w = vDialog.frame.size.width - bPadding * 2.0f;
	h = vDialog.frame.size.height - bPadding * 2.0f - lblHeight;
	[wvInfo setFrame:CGRectMake(x, y, w, h)];
	
	x = 0.0f;
	y = vDialog.frame.size.height - 50.0f;
	w = vDialog.frame.size.width;
	h = 50.0f;
	[ivShaderB setFrame:CGRectMake(x, y, w, h)];
	
	[wvInfo reload];
	
}


- (void)closeButton_TouchDown:(id)sender {
	[self animClose];
}

- (void)showInfo:(NSString *)titleOfPart filename:(NSString *)fileToLoad {
	if (!(self.view.hidden)) {
		sTitle = titleOfPart;
		sUrl = fileToLoad;
		[self animClose];
	}else{
		sTitle = @"";
		sUrl = @"";
        
        // Find the Library Resouce bundle in the Main Bundle
        NSBundle *staticBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"BodyScannerResources.bundle"]];
        
		//NSString *pdfPath2 = [[NSBundle mainBundle] pathForResource:fileToLoad ofType:@"htm"];
        NSString *pdfPath2 = [staticBundle pathForResource:fileToLoad ofType:@"htm"];
		NSURL *pdfURL = [NSURL fileURLWithPath:pdfPath2];
		NSURLRequest *URLReq = [NSURLRequest requestWithURL:pdfURL];
		[wvInfo loadRequest:URLReq];
		[lblTitle setText:titleOfPart];
		int fontSize = [self MaxOfFontForLabel:lblTitle andWidth:lblTitle.frame.size.width andHeight:lblTitle.frame.size.height];
		[lblTitle setFont:[lblTitle.font fontWithSize:(CGFloat)fontSize]];
		[self animShow];
	}
}
#pragma mark - Utilities

-(int)MaxOfFontForLabel:(UILabel *)lbl andWidth:(CGFloat)width andHeight:(CGFloat)height
{
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:28];
	NSString *t = [lbl text];
	
	if(t == @"") 
	{
		return 55;
	}
	int i;
	for(i = 36; i > 11; i=i-1)
	{
		font = [font fontWithSize:i];
		CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
		CGSize labelSize = [t sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		if(labelSize.height <= height )
			break;
	}
	return i;
}

#pragma mark -
#pragma mark Animation Funtions
- (void)animShow {
	bClose.userInteractionEnabled = NO;
	self.view.alpha = 0.0f;
	self.view.hidden = NO;
	[UIView beginAnimations:@"animShow" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];
	
}
- (void)animClose{
	[UIView beginAnimations:@"animPartClose" context:nil];
	if (parentController != nil) {
		[UIView setAnimationDelegate:parentController];
	}else {
		[UIView setAnimationDelegate:self];
	}
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if (animationID == @"animShow"/* && finished*/) {  
		bClose.userInteractionEnabled = YES;
	}
	if (animationID == @"animPartClose"/* && finished*/) {
		self.view.hidden = YES;
		//if (![sUrl isEqualToString:@""]) {
		//	[self showInfo:sTitle filename:sUrl];
		//}
	}
}



@end
