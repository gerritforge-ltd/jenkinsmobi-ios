// Copyright (C) 2012 LMIT Limited
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License.

#import <UIKit/UIKit.h>
#import "Configuration.h"

@class LegalNoticeViewController;
@class HudsonVersion;

@protocol FlipsideViewControllerDelegate;

@interface ProductInfoViewController : UIViewController {

	id<FlipsideViewControllerDelegate> delegate;
	UINavigationController* navController;
	IBOutlet UITextView* infoTextView;
	IBOutlet UILabel* versionLabel;
    IBOutlet UIButton* legalButton;
    IBOutlet UIImageView* logoImageView;
	HudsonVersion* versionChecker;
}

@property (assign) id<FlipsideViewControllerDelegate> delegate;
@property (nonatomic,retain) IBOutlet UIImageView* logoImageView;
@property (nonatomic,retain) IBOutlet UITextView* infoTextView;
@property (nonatomic,retain) IBOutlet UILabel* versionLabel;
@property (nonatomic,retain) IBOutlet UIButton* legalButton;
@property (assign) UINavigationController* navController;

-(IBAction)onOkClick:(id)sender;

-(IBAction)legalNoticeClick:(id)sender;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(ProductInfoViewController*) controller;
@end
