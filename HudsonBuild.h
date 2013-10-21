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
#import "FreeStyleBuildXmlParser.h"

@interface HudsonBuild : AbstractHudsonObject {

	int number;
	bool isBuilding;
	int duration;
	NSString* fullDisplayName;
	NSString* buildId;
	bool keepLog;
	NSString* result;
	NSString* timestamp;
	NSString* builtOn;
	
	int testFailCount;
	int testSkipCount;
	int testTotalCount;
	NSString* testReportUrl;
	NSMutableArray* artifacts;//an array of HudsonArtifact objects
}

@property (assign) int number;
@property (assign) bool isBuilding;
@property (assign) int duration;
@property (copy) NSString* fullDisplayName;
@property (copy) NSString* buildId;
@property (copy) NSString* result;
@property (copy) NSString* timestamp;
@property (assign) bool keepLog;
@property (copy) NSString* builtOn;
@property (assign) int testFailCount;
@property (assign) int testSkipCount;
@property (assign) int testTotalCount;
@property (copy) NSString* testReportUrl;
@property (assign) NSMutableArray* artifacts;

-(long)builtSince;
-(NSString*) builtSinceHumanReadable;
-(NSString*) durationeHumanReadable;

-(NSString*)humanReadableElapsed:(long)seconds;

@end
