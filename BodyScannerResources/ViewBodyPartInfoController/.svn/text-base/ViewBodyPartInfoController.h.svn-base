//
//  ViewBodyPartInfoController.h
//  iBreathe050
//
//  Created by Roger Reeder on 6/15/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

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

- (void)initDisplay;
- (void)updateLayout:(CGRect)frame;
- (void)animClose;
- (void)animShow;
- (void)showInfo:(NSString *)titleOfPart filename:(NSString *)fileToLoad;
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;

@end
