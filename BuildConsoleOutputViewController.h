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
#import "HudsonBuild.h"
#import "Configuration.h"
#import "SimpleHTTPGetter2.h"
#import "SimpleHTTPGetter.h"
#import "CloudBeesWebUtility.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BuildConsoleOutputViewController : UIViewController {

    IBOutlet UIScrollView* scrollView;
    IBOutlet UIWebView* htmlConsoleOutput;
    HudsonBuild* build;
    SimpleHTTPGetter* httpGetter;    
    NSTimer* timeoutTimer;
    
    BOOL showReloadOnActionSheet;
    BOOL showResumeOnActionSheet;
    BOOL showStopOnActionSheet;
    
    NSString* xConsoleAnnotator;
    NSString* xTextSize;
    BOOL hasMoreData;
    BOOL checkingSize;
}

@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic,retain) IBOutlet UIWebView* htmlConsoleOutput;
@property (copy) NSString* xTextSize;
@property (copy) NSString* xConsoleAnnotator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andBuild:(HudsonBuild*)_build;

@end
