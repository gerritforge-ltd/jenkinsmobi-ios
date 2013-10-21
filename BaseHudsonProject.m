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

#import "BaseHudsonProject.h"

@implementation BaseHudsonProject

@synthesize type, recentBuilds, isInQueue, isBuildable, nextBuildNumber, queueDescriptor, trend;
@synthesize firstBuild, lastBuild, lastCompletedBuild, lastFailedBuild, lastStableBuild, lastSuccessfulBuild, buildStabilityReport, testStabilityReport;

-(id)init{
	
    self = [super init];
    
	if(self){
		
		trend = [[HudsonProjectTrend alloc] initWithProject:self];
		recentBuilds = [[NSMutableArray alloc] init];
		xmlDataParser = [[FreeStyleProjectXmlParser alloc] initWithCaller:self andObjectToStore:self];        
        if([[Configuration getInstance] useXpath]){
            [self setXPathQueryString:@"tree=healthReport[description,iconUrl,score],url,description,iconUrl,displayName,name,buildable,color,blocked,stuck,why,inQueue,builds[number,url],lastBuild[url,number],modules[url,color,displayName,name]"];
        }
	}
	
	return self;
}

-(void)loadHudsonObject{
	//to cleanup
	[self reload];
}

-(void)reload{
	
	[recentBuilds removeAllObjects];
	[[trend trendItemList] removeAllObjects];
	
	if(queueDescriptor!=nil){
		[queueDescriptor release];
		queueDescriptor = nil;
	}
	
	if(firstBuild!=nil){
		[firstBuild release];
		firstBuild = nil;
	}
	
	if(lastBuild!=nil){
		[lastBuild release];
		lastBuild = nil;
	}
	
	if(lastCompletedBuild!=nil){
		[lastCompletedBuild release];
		lastCompletedBuild = nil;
	}
	
	if(lastFailedBuild!=nil){
		[lastFailedBuild release];
		lastFailedBuild = nil;
	}	
	
	if(lastStableBuild!=nil){
		[lastStableBuild release];
		lastStableBuild = nil;
	}	
	
	if(lastSuccessfulBuild!=nil){
		[lastSuccessfulBuild release];
		lastSuccessfulBuild = nil;
	}	
	
	if(buildStabilityReport!=nil){
		[buildStabilityReport release];
		buildStabilityReport = nil;
	}
	
	if(testStabilityReport!=nil){
		[testStabilityReport release];
		testStabilityReport = nil;
	}
	
	if(type!=nil){
		[type release];
		type = nil;
	}
	
	[super loadHudsonObject];
}

-(void)loadLastTrend{
	
	[[trend trendItemList] removeAllObjects];
	[trend setDelegate:self];
	[trend loadLastBuildOnly];
}

-(void)loadTrend{
	
	[[trend trendItemList] removeAllObjects];
	[trend setDelegate:self];
	[trend loadHudsonObject];
}

-(void)loadTrendUpToBuilds:(int)buildToLoad{

	[[trend trendItemList] removeAllObjects];
	[trend setDelegate:self];
	[trend loadUpToBuilds:buildToLoad];
}

-(void)loadTrendNextBuilds:(int)buildToLoad{
	
	//[[trend trendItemList] removeAllObjects];
	[trend setDelegate:self];
	[trend loadNextBuilds:buildToLoad];
}

- (void) dealloc
{

	[recentBuilds release];
	
	if(queueDescriptor!=nil){
		[queueDescriptor release];
	}
	
	if(firstBuild!=nil){
		[firstBuild release];
	}

	if(lastBuild!=nil){
		[lastBuild release];
	}

	if(lastCompletedBuild!=nil){
		[lastCompletedBuild release];
	}	
	
	if(lastFailedBuild!=nil){
		[lastFailedBuild release];
	}	
	
	if(lastStableBuild!=nil){
		[lastStableBuild release];
	}	
	
	if(lastSuccessfulBuild!=nil){
		[lastSuccessfulBuild release];
	}	

	if(buildStabilityReport!=nil){
		[buildStabilityReport release];
	}
	
	if(testStabilityReport!=nil){
		[testStabilityReport release];
	}
	
	if(type!=nil){
		[type release];
	}
	
	[trend release];
	
	[super dealloc];
}


@end
