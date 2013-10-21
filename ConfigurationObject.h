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

#import <Foundation/Foundation.h>
#include "Configuration.h"

@interface ConfigurationObject : NSObject {

	NSString* filename;
	
	NSString* url;
	NSString* hudsonHostname;
	NSString* username;
	NSString* password;
    NSString* lastTimeWasOnline;
    BOOL useXpath;
    BOOL overrideHudsonURLWithConfiguredOne;
	int connectionTimeout;
	NSString* portNumber;
	NSString* hudsonVersion;
	NSString* description;
	NSString* protocol;
	NSString* suffix;
	int maxBuildsNumberToLoadAtTime;
    int maxConsoleOutputSize;
}

@property (nonatomic,retain) NSString* url;
@property (nonatomic,retain) NSString* portNumber;
@property (nonatomic,retain) NSString* username;
@property (nonatomic,retain) NSString* password;
@property (assign) BOOL useXpath;
@property (nonatomic,retain) NSString* lastTimeWasOnline;
@property (assign) BOOL overrideHudsonURLWithConfiguredOne;
@property (assign) int connectionTimeout;
@property (assign) int maxConsoleOutputSize;
@property (assign) int maxBuildsNumberToLoadAtTime;
@property (nonatomic,retain) NSString* hudsonVersion;
@property (nonatomic,retain) NSString* hudsonHostname;
@property (nonatomic,retain) NSString* filename;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) NSString* protocol;
@property (nonatomic,retain) NSString* suffix;

-(void)remove;
-(void)saveConfiguration;
-(void)loadConfiguration:(NSString*)_filename;

-(NSString*)getCompleteURL;

@end
