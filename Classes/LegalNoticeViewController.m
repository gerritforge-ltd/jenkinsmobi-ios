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
#import "LegalNoticeViewController.h"
#import "Configuration.h"

@implementation LegalNoticeViewController

@synthesize noticeText;

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.navigationItem setTitle:NSLocalizedString(@"Legal notice",nil)];
	[[self navigationController] setNavigationBarHidden:NO];
	[self.navigationItem setHidesBackButton:YES];
	
	[noticeText setFont:[UIFont systemFontOfSize:12.f]];
    
    NSString* legalNoticeFileName = nil;
    
    if([[[Configuration getInstance] productName] isEqualToString:@"HudsonMobi"]){
        legalNoticeFileName = @"legalnotice_hudson";
    }else if([[[Configuration getInstance] productName] isEqualToString:@"JenkinsMobi"]){
        legalNoticeFileName = @"legalnotice_jenkins";
    }

    NSString* filePath = [[NSBundle mainBundle] pathForResource:legalNoticeFileName ofType:@"txt"];
    [noticeText setText:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]];
}

-(IBAction)onOkClick:(id)sender{
	
	[self.navigationController popToRootViewControllerAnimated:NO];
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


@end
