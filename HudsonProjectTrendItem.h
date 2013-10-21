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
#import "AbstractHudsonObject.h"

@class ProjectTrendsXmlDataParser;
@class HudsonTestListXmlDataParser;
@class HudsonBuild;
@class HudsonTest;

@interface HudsonProjectTrendItem : AbstractHudsonObject {
	
	HudsonBuild* parent;
	NSString* result;
	NSString* timestamp;	
	int totalTests;	
	int totalSkipped;
	int totalFailed;
	int number;
	NSMutableArray* failedTests; //an array of HudsonTest objects
}

@property (copy) NSString* result;
@property (assign) int totalTests;	
@property (assign) int totalSkipped;
@property (assign) int totalFailed;
@property (copy) NSString* timestamp;
@property (assign) int number;
@property (assign) HudsonBuild* parent;
@property (assign) NSMutableArray* failedTests;

-(id)initWithBuild:(HudsonBuild*)build;
-(NSString*)buildDate;
-(void)loadFailedTests:(int)from:(int)to;

@end
