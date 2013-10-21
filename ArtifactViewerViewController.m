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

#import "ArtifactViewerViewController.h"


@implementation ArtifactViewerViewController

@synthesize txtView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withBuild:(HudsonBuild*)build andArtifact:(HudsonArtifact*)artifact {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

		currentBuild = build;
		currentArtifact =  artifact;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:[currentArtifact fileName]];

	loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Downloading...",nil)];
	
	getter = [[SimpleHTTPGetter alloc] init];
	NSString* artifactUrl = [NSString stringWithFormat:@"%@/artifact/%@",[currentBuild url],[currentArtifact relativePath]];
	[getter httpGET:artifactUrl :self];
}

- (void) receiveData:(NSData*)data{
	 
	 if(data==nil){
		 
		 [Logger info:@"No data received"];
		 [self onLoadFinisched];
		 return;
	 }
	 
	txtData = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	 
	 if(txtData==NULL){
		 
		 [Logger error:@"Response null"];
		 [self onLoadFinisched];
		 return;
	 }
	 
	 if([txtData isEqualToString:@"403"]){
		 
		 [Logger error:@"Load finished with errors: 403"];
		 [self onLoadFinischedWithErrors];
		 return;		
	 }
	
	[self onLoadFinisched];
}	
					 
-(void)onLoadFinischedWithErrors{
	 
	if(loadingView!=nil){
		
		[loadingView removeFromSuperview];
		loadingView=nil;
	}
	
	[txtView setText:NSLocalizedString(@"Cannot read artifact data",nil)];
}
 
-(void)onLoadFinisched{
	 
	if(loadingView!=nil){
	
		[loadingView removeFromSuperview];
		loadingView=nil;
	}
	
	[txtView setText:txtData];
}					 

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
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
	
	if(txtData!=nil){
		[txtData release];
	}
	
	if(getter!=nil){
		[getter release];
	}
    [super dealloc];
}


@end
