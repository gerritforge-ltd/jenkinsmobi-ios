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

#import "ProductInfoViewController.h"

@implementation ProductInfoViewController

@synthesize logoImageView,delegate,infoTextView, versionLabel,navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [legalButton setTitle:NSLocalizedString(@"Legal", nil) forState:UIControlStateNormal];
    
    //set correct image
    if([[[Configuration getInstance] targetCIProductName] isEqualToString:@"Hudson"]){
        [[self logoImageView] setImage:[UIImage imageNamed:@"hudsonmobi-logo-only-text.png"]];
    }else if([[[Configuration getInstance] targetCIProductName] isEqualToString:@"Jenkins"]){
        [[self logoImageView] setImage:[UIImage imageNamed:@"jenkinsmobi-logo-only-text.png"]];
    }
    
	UIDevice* device  = [UIDevice currentDevice];
	
	NSMutableString* stringBuilder = [[NSMutableString alloc] init];
	[stringBuilder appendFormat:@"ID: %@\n",[device uniqueIdentifier]];
	[stringBuilder appendFormat:NSLocalizedString(@"Device model: %@\n",nil),[device model]];
	[stringBuilder appendFormat:NSLocalizedString(@"Name: %@\n",nil),[device name]];
	[stringBuilder appendFormat:NSLocalizedString(@"OS: %@\n",nil),[device systemName]];
	[stringBuilder appendFormat:NSLocalizedString(@"OS version: %@\n",nil),[device systemVersion]];

	[infoTextView setFont:[UIFont systemFontOfSize:13.f]];
	[infoTextView setText:stringBuilder];
	[stringBuilder release];
	
	Configuration* conf = [Configuration getInstance];
	[versionLabel setText:[NSString stringWithFormat:NSLocalizedString(@"v. %@ - %@ API version: checking...",nil),[conf productVersion],[conf targetCIProductName]]];

	versionChecker = [[HudsonVersion alloc] init];
	[versionChecker setDelegate:self];
	[versionChecker checkVersion];
}

-(void)onVersionCheckFinisched{
	
	Configuration* conf = [Configuration getInstance];
	
	if([conf hudsonVersion]!=nil){
		[versionLabel setText:[NSString stringWithFormat:NSLocalizedString(@"v. %@ - %@ API version: %@",nil),[conf productVersion],[conf targetCIProductName],[conf hudsonVersion]]];
	}else{
		[versionLabel setText:[NSString stringWithFormat:NSLocalizedString(@"v. %@ - %@ API version: unknown",nil),[conf productVersion],[conf targetCIProductName]]];
	}
}

-(void)onLoadFinischedWithErrors{

    [self onVersionCheckFinisched];
}

-(IBAction)legalNoticeClick:(id)sender{

	[versionChecker stopLoad];
	LegalNoticeViewController *anotherViewController = [[LegalNoticeViewController alloc] initWithNibName:@"LegalNoticeViewController" bundle:nil];
	[navController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];	
	[delegate flipsideViewControllerDidFinish:self];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)onOkClick:(id)sender{
	
	[versionChecker stopLoad];
	[delegate flipsideViewControllerDidFinish:self];
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
	if(versionChecker!=nil){
		[versionChecker release];
	}
    [super dealloc];
}


@end
