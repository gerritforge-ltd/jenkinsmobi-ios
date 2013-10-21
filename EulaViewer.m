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

#import "EulaViewer.h"

@implementation EulaViewer

@synthesize delegate,navBarTitleItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)onFinishClick:(id)sender{
	
    Configuration* conf = [Configuration getInstance];
    
    if(eulaCheckboxSelected){
    
        [conf setEulaAccepted:YES];
        [conf setAuditAccepted:auditCheckboxSelected];
        [conf saveConfiguration];
        
        [delegate flipsideViewControllerDidFinish:self];
        [delegate performSelector:@selector(onEulaViewDismissed)];
    }else{
    
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EULA",nil) message:[NSString stringWithFormat:NSLocalizedString(@"You have to agree with all EULA conditions to use %@",nil),[conf productName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(IBAction)onEulaCheckSelected:(id)sender{

    if (eulaCheckboxSelected == 0){
        [eulaAcceptSwitch setSelected:YES];
        eulaCheckboxSelected = 1;
    } else {
        [eulaAcceptSwitch setSelected:NO];
        eulaCheckboxSelected = 0;
    }

}

-(IBAction)onAuditCheckSelected:(id)sender{

    if (auditCheckboxSelected == 0){
        [auditAcceptSwitch setSelected:YES];
        auditCheckboxSelected = 1;
    } else {
        [auditAcceptSwitch setSelected:NO];
        auditCheckboxSelected = 0;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navBarTitleItem setTitle:NSLocalizedString(@"Please, read carefully",nil)];
    
    [finishButton setTitle:NSLocalizedString(@"Finish", nil) forState:UIControlStateNormal];
    [eulaAcceptSwitchLabel setText:NSLocalizedString(@"I agree with the terms above", nil)];
    [auditAcceptSwitchLabel setText:NSLocalizedString(@"I agree to send anonymous feedback", nil)];
    
    NSString* language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString* htmlFileName=[NSString stringWithFormat:@"eula.%@",language];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"txt"];
    NSData *_htmlData = [NSData dataWithContentsOfFile:filePath];
    [webView loadData:_htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
