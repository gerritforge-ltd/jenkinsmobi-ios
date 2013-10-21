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

#import "BuildConsoleOutputViewController.h"

@implementation BuildConsoleOutputViewController

@synthesize xTextSize,xConsoleAnnotator,htmlConsoleOutput,scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andBuild:(HudsonBuild*)_build
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        build = _build;
        [self setXTextSize:@"0"];
        showReloadOnActionSheet = NO;
        showResumeOnActionSheet = NO;
        showStopOnActionSheet = YES;
        
        checkingSize = YES;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)__scrollView{
    return scrollView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Console Output",nil)];
    
    [self setMoreButton];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"build_output" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    if (htmlData) {
        [htmlConsoleOutput setDelegate:self];
        [htmlConsoleOutput loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self fireTimer];
}

#pragma  data receive handling
-(void) receiveData:(NSData*)data andHeaders:(NSDictionary *)headers{
    
    [self setXConsoleAnnotator:[headers valueForKey:@"X-Consoleannotator"]];
    [self setXTextSize:[headers valueForKey:@"X-Text-Size"]];
    hasMoreData = [[headers valueForKey:@"X-More-Data"] isEqualToString:@"true"];
    
    if(checkingSize){
       
        checkingSize = NO;
        
        int maxConsoleSize = [[Configuration getInstance] maxConsoleOutputSize];
        
        int xTextSizeAsInt = [[self xTextSize] intValue];

        if(xTextSizeAsInt > maxConsoleSize){
            [self setXTextSize:[NSString stringWithFormat:@"%d",(xTextSizeAsInt - maxConsoleSize)]];
        }else{
            [self setXTextSize:@"0"];
        }
        
        [self fireTimer];
        return;
    }
    
    NSInputStream* inStream = [NSInputStream inputStreamWithData:data];
    [inStream open];
    NSString* line = nil;
    while((line = [CloudBeesWebUtility readLineFromStream:inStream])!=nil){
        NSString* javascript = [NSString stringWithFormat:@"fetchNext('%@', 1);",line];
        [htmlConsoleOutput stringByEvaluatingJavaScriptFromString:javascript];
    }
    [inStream close];
    
    if(httpGetter!=nil){
        [httpGetter release];
        httpGetter = nil;
    }
    
    if(hasMoreData){
        
        //[self fireTimer];
        
    }else{
        
        [self stopTimer];
        
        NSString* javascript = @"fetchNext('', 0);";
        [htmlConsoleOutput stringByEvaluatingJavaScriptFromString:javascript];
    
        [self setReloadButton];
    }
}

-(IBAction)moreButtonClick:(id)sender{
    
    UIActionSheet* actionSheet = nil;
    
    if(showReloadOnActionSheet){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                         cancelButtonTitle:nil destructiveButtonTitle:NSLocalizedString(@"Cancel",nil) 
                                                        otherButtonTitles:NSLocalizedString(@"Reload",nil),NSLocalizedString(@"Email log",nil), nil];
    }else if(showStopOnActionSheet){
       actionSheet =  [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                           cancelButtonTitle:nil destructiveButtonTitle:NSLocalizedString(@"Cancel",nil) 
                           otherButtonTitles:NSLocalizedString(@"Stop",nil),NSLocalizedString(@"Email log",nil), nil];    
    }else if(showResumeOnActionSheet){
    
        actionSheet =  [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                          cancelButtonTitle:nil destructiveButtonTitle:NSLocalizedString(@"Cancel",nil) 
                                          otherButtonTitles:NSLocalizedString(@"Resume",nil),NSLocalizedString(@"Email log",nil), nil];
    }
    
    [actionSheet showFromBarButtonItem:[self.navigationItem rightBarButtonItem] animated:YES];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            if(showReloadOnActionSheet){
                [self reloadButtonClick:nil];
            }else if(showStopOnActionSheet){
                [self stopButtonClick:nil];            
            }else if(showResumeOnActionSheet){
                [self resumeButtonClick:nil];            
            }
            break;
        case 2:
            [self emailLog];
            break;
        default:
            break;
    }
}

-(IBAction)reloadButtonClick:(id)sender{
    
    [self setXTextSize:@"0"];
    checkingSize = YES;
    
    [self setStopButton];
  
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"build_output" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    [htmlConsoleOutput loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

-(IBAction)resumeButtonClick:(id)sender{
        
    NSString* javascript = @"showSpinner();";
    [htmlConsoleOutput stringByEvaluatingJavaScriptFromString:javascript];
    
    [self setStopButton];
    
    [self fireTimer];
}


-(IBAction)stopButtonClick:(id)sender{
    
    NSString* javascript = @"hideSpinner();";
    [htmlConsoleOutput stringByEvaluatingJavaScriptFromString:javascript];
    
    [self setResumeButton];
    
    [self stopTimer];
    
    if(httpGetter!=nil){
    
        [httpGetter stop];
        [httpGetter release];
        httpGetter = nil;
    }
}

-(void)setReloadButton{

    showReloadOnActionSheet = YES;
    showStopOnActionSheet = NO;
    showResumeOnActionSheet = NO;
}

-(void)setResumeButton{
    
    showReloadOnActionSheet = NO;
    showStopOnActionSheet = NO;
    showResumeOnActionSheet = YES;
}

-(void)setStopButton{

    showReloadOnActionSheet = NO;
    showStopOnActionSheet = YES;
    showResumeOnActionSheet = NO;;
}

-(void)setMoreButton{
    UIBarButtonItem* moreButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonItemStyleBordered
                                                                              target:self action:@selector(moreButtonClick:)];
    [self.navigationItem setRightBarButtonItem:moreButton];
    [moreButton release];
}

-(void)fireTimer{
    
	timeoutTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timeoutOccurred:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timeoutTimer forMode:NSDefaultRunLoopMode];
}

-(void)stopTimer{
    
	if(timeoutTimer!=nil){
		[timeoutTimer invalidate];
		timeoutTimer = nil;
	}
}

-(void)timeoutOccurred:(NSTimer*)theTimer{
    
    httpGetter = [[SimpleHTTPGetter alloc] init];

    if(checkingSize){
        [self stopTimer];
        [httpGetter setCheckOnlyStatusCode:YES];
    }
    
    
    NSMutableString* queryString = [[NSMutableString alloc] init];
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    if(xConsoleAnnotator!=nil){
        [headers setValue:xConsoleAnnotator forKey:@"X-ConsoleAnnotator"];  
    }
    
    [queryString appendFormat:@"?start=%@",[self xTextSize],nil];
    
    NSString* url = [NSString stringWithFormat:@"%@/logText/progressiveHtml%@",[build url],queryString,nil];
    
    [httpGetter httpGET:url withUsername:[[Configuration getInstance] username] andPassword:[[Configuration getInstance] password] andDataReceiver:self andHeaders:headers];
}

-(void)emailLog {
	
    NSString* javascript = @"document.getElementById('out').innerHTML;";
    NSMutableString* htmlPageBuilder  = [[NSMutableString alloc] init];
    [htmlPageBuilder appendString:[NSString stringWithFormat:@"<!-- Sent with %@ (c)2010-2011 LMIT Software Ltd -->",[[Configuration getInstance] productName]]];
    [htmlPageBuilder appendString:@"<html><head><title></title></head><body>"];
    [htmlPageBuilder appendString:[htmlConsoleOutput stringByEvaluatingJavaScriptFromString:javascript]];
    [htmlPageBuilder appendString:@"</body></html>"];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate:self];
    [controller setSubject:[build description]];
    [controller setToRecipients:nil];
    [controller addAttachmentData:[htmlPageBuilder dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/html" fileName:@"console.html"];
    [controller setMessageBody:@"" isHTML:NO];
    [self.navigationController presentModalViewController:controller animated:YES];
    [controller release];
    [htmlPageBuilder release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	[self dismissModalViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
        
    [self stopButtonClick:nil];

    [super viewWillDisappear:animated];
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
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait)||(;
}

@end
