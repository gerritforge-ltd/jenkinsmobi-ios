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

@class HudsonBuild;
@class HudsonQueueItem;
@class HudsonHealthReport;
@class FreeStyleProjectXmlParser;
@class HudsonProjectTrend;
@class HudsonProjectTrendItem;

@interface BaseHudsonProject : AbstractHudsonObject {
	
	NSString* type;
	bool isBuildable;
	bool isInQueue;
	int nextBuildNumber;
	NSMutableArray* recentBuilds; //array of HudsonBuild objects
	
	HudsonProjectTrend* trend;
	HudsonQueueItem* queueDescriptor;
	HudsonBuild* firstBuild;
	HudsonBuild* lastBuild;
	HudsonBuild* lastCompletedBuild;
	HudsonBuild* lastFailedBuild;
	HudsonBuild* lastStableBuild;
	HudsonBuild* lastSuccessfulBuild;
	HudsonHealthReport* buildStabilityReport;
	HudsonHealthReport* testStabilityReport;
	
	bool monitored; 
}

@property (copy) NSString* type;
@property (assign) bool isBuildable;
@property (assign) bool isInQueue;
@property (assign) int nextBuildNumber;
@property (assign) NSMutableArray* recentBuilds; //array of HudsonBuild objects
@property (assign) HudsonQueueItem* queueDescriptor;
@property (assign) HudsonBuild* firstBuild;
@property (assign) HudsonBuild* lastBuild;
@property (assign) HudsonBuild* lastCompletedBuild;
@property (assign) HudsonBuild* lastFailedBuild;
@property (assign) HudsonBuild* lastStableBuild;
@property (assign) HudsonBuild* lastSuccessfulBuild;
@property (assign) HudsonHealthReport* buildStabilityReport;
@property (assign) HudsonHealthReport* testStabilityReport;
@property (assign) HudsonProjectTrend* trend;

-(void)reload;

-(void)loadTrend;

-(void)loadTrendUpToBuilds:(int)buildToLoad;
-(void)loadTrendNextBuilds:(int)buildToLoad;

@end
