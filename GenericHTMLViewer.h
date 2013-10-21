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
#import "LoadingView.h"

@interface GenericHTMLViewer : UIViewController {

    IBOutlet UIWebView* webView;
    NSString* htmlFileName;
    NSString* title;
    NSString* url;
    NSString* htmlData;
    
    LoadingView* loadingView;
    BOOL authChallengeReceived;
    BOOL showReloadButton;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (assign) BOOL showReloadButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFileName:(NSString*)__htmlFileName andTitle:(NSString*)__title andURL:(NSString*)__url andData:(NSString*)__htmlData;

@end
