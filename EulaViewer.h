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

@protocol FlipsideViewControllerDelegate;

@interface EulaViewer : UIViewController

{
    id<FlipsideViewControllerDelegate> delegate;
    IBOutlet UIButton* finishButton;
    IBOutlet UIWebView* webView;
    IBOutlet UIButton* eulaAcceptSwitch;
    IBOutlet UIButton* auditAcceptSwitch;
    IBOutlet UILabel* eulaAcceptSwitchLabel;
    IBOutlet UILabel* auditAcceptSwitchLabel;
    IBOutlet UINavigationItem* navBarTitleItem;
    BOOL eulaCheckboxSelected;
    BOOL auditCheckboxSelected;
}

@property (nonatomic,retain) IBOutlet UINavigationItem* navBarTitleItem;
@property (nonatomic,retain) id<FlipsideViewControllerDelegate> delegate;
@property (nonatomic,retain) IBOutlet UIButton* finishButton;
@property (nonatomic,retain) IBOutlet UIWebView* webView;
@property (nonatomic,retain) IBOutlet UIButton* eulaAcceptSwitch;
@property (nonatomic,retain) IBOutlet UIButton* auditAcceptSwitch;
@property (nonatomic,retain) IBOutlet UILabel* eulaAcceptSwitchLabel;
@property (nonatomic,retain) IBOutlet UILabel* auditAcceptSwitchLabel;

@end
