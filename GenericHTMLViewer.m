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

#import "GenericHTMLViewer.h"

@implementation GenericHTMLViewer

@synthesize showReloadButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFileName:(NSString*)__htmlFileName andTitle:(NSString*)__title andURL:(NSString*)__url andData:(NSString*)__htmlData
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        htmlFileName = __htmlFileName;
        title = __title;
        url = __url;
        htmlData = __htmlData;
        authChallengeReceived = NO;
        showReloadButton = YES;
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

#pragma mark - View lifecycle

-(void)onStopButtonClick:(id)sender{
 
    if(loadingView!=nil){
        [loadingView removeView];
        loadingView = nil;
    }
    
    [webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];    
    
    UIBarButtonItem* restartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRestartButtonClick:)];
    [self.navigationItem setRightBarButtonItem:restartButton];
    [restartButton release];
}

-(void)onRestartButtonClick:(id)sender{
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [webView reload];
    
    UIBarButtonItem* stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onStopButtonClick:)];
    [self.navigationItem setRightBarButtonItem:stopButton];
    [stopButton release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setTitle:title];
    
    if(showReloadButton==YES){
        UIBarButtonItem* stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onStopButtonClick:)];
        [self.navigationItem setRightBarButtonItem:stopButton];
        [stopButton release];
    }
    
    loadingView = [LoadingView loadingViewInView:self.view];
    
    if(htmlFileName!=nil){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html"];
        NSData *_htmlData = [NSData dataWithContentsOfFile:filePath];
        if (_htmlData) {
            authChallengeReceived = YES;// to force the loadingview removal
            [webView setDelegate:self];
            [webView loadData:_htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
        }
    }else if(htmlData!=nil){

        NSData *_htmlData =[htmlData dataUsingEncoding:NSUTF8StringEncoding];
        authChallengeReceived = YES;// to force the loadingview removal
        [webView setDelegate:self];
        [webView loadData:_htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
    }else{
        
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [webView setDelegate:self];
        [webView loadRequest:urlRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated{

    [self onStopButtonClick:nil];
    [super viewWillDisappear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

    if(authChallengeReceived){

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    if(authChallengeReceived){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [loadingView removeView];
        loadingView = nil;
        
        if(showReloadButton==YES){
            UIBarButtonItem* restartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRestartButtonClick:)];
            [self.navigationItem setRightBarButtonItem:restartButton];
            [restartButton release];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if(authChallengeReceived==NO){
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        return NO;
        
    }else{
    
        return YES;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{   
    if(authChallengeReceived==NO){
        
        authChallengeReceived = YES;
        
        if ([challenge previousFailureCount] == 0) {
            /* SET YOUR credentials, i'm just hard coding them in, tweak as necessary */
            [[challenge sender] useCredential:[NSURLCredential credentialWithUser:[[Configuration getInstance] username] password:[[Configuration getInstance] password] persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
        } else {
            [[challenge sender] cancelAuthenticationChallenge:challenge]; 
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{    
    authChallengeReceived = YES; //if i'm here the auth challenge is received : force it to yes for those server with no server auth
    /** THIS IS WHERE YOU SET MAKE THE NEW REQUEST TO UIWebView, which will use the new saved auth info **/
    [connection cancel];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView setDelegate:self];
    [webView loadRequest:urlRequest];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
{
    return NO;
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
