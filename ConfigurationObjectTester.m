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

#import "ConfigurationObjectTester.h"


@implementation ConfigurationObjectTester

@synthesize delegate;

-(id)initWithConfigurationToTest:(ConfigurationObject*)confObject{

    self = [super init];
    if (self) {
	
		currentTestingConfiguration = confObject;
		retrieveVersionTest = TEST_FAILED;
		retrieveViewListTest = TEST_FAILED;
		loginTest =  TEST_FAILED;
	}
	
	return self;
}

-(void)test{

	[self checkVersion];
}

-(void)checkVersion{
	
	[Logger info:@"GetVersion test in progress..."];
	versionChecker = [[HudsonVersion alloc] init];
	[versionChecker setDelegate:self];
	[versionChecker checkVersion];
}

-(void)onVersionCheckFinisched{
	
	//Configuration* conf = [Configuration getInstance];
	//if([conf hudsonVersion]!=nil && [[conf hudsonVersion] length]>0){
	if([SimpleHTTPGetter getLastHttpStatusCode]==200){
		[Logger info:@"GetVersion Test passed"];
		retrieveVersionTest = TEST_PASSED;
	}else{
	
		[Logger info:@"GetVersion Test failed"];
		retrieveVersionTest = TEST_FAILED;
	}
	
	[self getViewList];
}

-(void)getViewList{

	[Logger info:@"GetViewList test in progress..."];
	
	login = [[HudsonLoginObject alloc] init];
	[login setDelegate:self];
	[login doLogin];
}

-(void)onAuthorizationGranted{
	
	loginTest = TEST_PASSED;

	viewList = [[HudsonViewList alloc] init];
	[viewList setDelegate:self];
	[viewList loadHudsonObject];
}

-(void)onAuthorizationDenied{
	
	loginTest = TEST_FAILED;
	
	viewList = [[HudsonViewList alloc] init];
	[viewList setSilentMode:YES];
	[viewList setDelegate:self];
	[viewList loadHudsonObject];
}
	
-(void)onLoadFinisched{
	
	[Logger info:@"GetViewList Test passed"];	
	retrieveViewListTest = TEST_PASSED;
	[self checkResults];
}

-(void)onLoadFinischedWithErrors{
	
	[Logger info:@"GetViewList Test failed"];
	retrieveViewListTest = TEST_FAILED;
	[self checkResults];
}

-(void)checkResults{

	
	NSMutableString* stringBuilder = [[NSMutableString alloc] init];
	if(loginTest==TEST_FAILED){
		[stringBuilder appendString:@"Login: FAILED\n"];
	}else{
		[stringBuilder appendString:@"Login: OK\n"];
	}
	if(retrieveVersionTest==TEST_FAILED){
		[stringBuilder appendString:@"Hudson version: FAILED\n"];
	}else{
		[stringBuilder appendString:@"Hudson version: OK\n"];
	}
	if(retrieveViewListTest==TEST_FAILED){
		[stringBuilder appendString:@"Hudson view: FAILED\n"];
	}else{
		[stringBuilder appendString:@"Hudson view: OK\n"];
	}
	
	if(loginTest==TEST_PASSED && 
	   retrieveVersionTest==TEST_PASSED && 
	   retrieveViewListTest==TEST_PASSED){
		
		[delegate performSelector:@selector(configurationTestPassed:) withObject:stringBuilder];
		
	}else{
		
		[delegate performSelector:@selector(configurationTestFailed:) withObject:stringBuilder];
	}
	
	[stringBuilder release];
}

- (void) dealloc
{
	[versionChecker release];
	[login release];
	[viewList release];
	[super dealloc];
}


@end
