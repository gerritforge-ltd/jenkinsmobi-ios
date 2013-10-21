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

#import "HudsonProjectTrend.h"

@implementation HudsonProjectTrend

@synthesize trendItemList;

-(id)initWithProject:(BaseHudsonProject*)project{

    self = [super init];
    
	if(self){
		
		currentProject = project;
		trendItemList = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(void)loadHudsonObject{
	
	if([trendItemList count]==0){
		
		buildToStat = [[currentProject recentBuilds] count];
		for (HudsonBuild* build in [currentProject recentBuilds]) {
			
			HudsonProjectTrendItem* trendItem = [[HudsonProjectTrendItem alloc] initWithBuild:build];
			[trendItemList addObject:trendItem];
			[trendItem setDelegate:self];
			[trendItem loadHudsonObject];
		}
		
	}else{
		
		//notify delegate immediately
		[super onLoadFinisched];
	}
}

-(void)loadUpToBuilds:(int)buildToLoad{
	
	
	if([trendItemList count]==0){
		
		buildToStat = [[currentProject recentBuilds] count];
		if(buildToStat > buildToLoad){
			buildToStat =  buildToLoad;
		}else if(buildToLoad > buildToStat){
			buildToLoad = buildToStat;
		}
		
		for (HudsonBuild* build in [currentProject recentBuilds]) {
			
			HudsonProjectTrendItem* trendItem = [[HudsonProjectTrendItem alloc] initWithBuild:build];
			[trendItemList addObject:trendItem];
			[trendItem setDelegate:self];
			[trendItem loadHudsonObject];
			
			buildToLoad--;
			if(buildToLoad==0){
				break;
			}
		}
		
	}else{
	
		//notify delegate immediately
		[super onLoadFinisched];
	}
}

//load next buildToLoad builds and add them to the already loaded builds
-(void)loadNextBuilds:(int)buildToLoad{
	
	if([trendItemList count]==[[currentProject recentBuilds] count]){
	
		buildToStat = 0;
		//notify delegate immediately
		[super onLoadFinisched];
	}
	
	buildToStat =  buildToLoad;
	int nextLastIndex = [trendItemList count] + buildToLoad;
	
	for(int i=[trendItemList count]; i < nextLastIndex 
			&& i < [[currentProject recentBuilds] count];i++){
	
		if(i == nextLastIndex - 1 || i == [[currentProject recentBuilds] count] - 1){
			buildToStat = 0;
		}
		
		HudsonBuild* build = [[currentProject recentBuilds] objectAtIndex:i];
		HudsonProjectTrendItem* trendItem = [[HudsonProjectTrendItem alloc] initWithBuild:build];
		[trendItemList addObject:trendItem];
		[trendItem setDelegate:self];
		[trendItem loadHudsonObject];
	}
}

-(void)loadLastBuildOnly{
	
	
	if([[currentProject recentBuilds] count]>0){
		
		buildToStat = 1;
		
		HudsonBuild* build = [[currentProject recentBuilds] objectAtIndex:0];
			
		HudsonProjectTrendItem* trendItem = [[HudsonProjectTrendItem alloc] initWithBuild:build];
		[trendItemList addObject:trendItem];
		[trendItem setDelegate:self];
		[trendItem loadHudsonObject];
	}
}

-(void)onLoadFinisched{
	
	buildToStat--;
	
	if(buildToStat<=0){

		[super onLoadFinisched];
	}
}

-(int)maxTestNumber{
	int max = -1;
	for (HudsonProjectTrendItem* trendItem in trendItemList) {
		
		if(max==-1 || max < [trendItem totalTests]){
			
			max = [trendItem totalTests];
		}
	}
	
	return max;
	
}

- (void) dealloc
{
	[trendItemList release];
	[super dealloc];
}


@end
