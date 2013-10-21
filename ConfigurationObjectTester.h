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
#import "Logger.h"

@class Configuration;
@class ConfigurationObject;
@class HudsonVersion;
@class HudsonViewList;
@class SimpleHTTPGetter;
@class HudsonLoginObject;

#define TEST_NOT_PERFORMED 0
#define TEST_PASSED 1
#define TEST_FAILED 2

@interface ConfigurationObjectTester : NSObject {

	ConfigurationObject* currentTestingConfiguration;
	int retrieveVersionTest;
	int loginTest;	
	int retrieveViewListTest;
	id delegate;
	
	HudsonVersion* versionChecker;
	HudsonLoginObject* login;
	HudsonViewList* viewList;
}

@property (assign) id delegate;

-(id)initWithConfigurationToTest:(ConfigurationObject*)confObject;

-(void)test;

@end
