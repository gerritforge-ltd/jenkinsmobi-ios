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

#import "HudsonChange.h"

@implementation HudsonChange

@synthesize date,message,type,revision, user,kind, modifiedFiles,addedFiles, removedFiles, merge;

-(id) init{

    self = [super init];
    
	if(self){
	
		modifiedFiles = [[NSMutableArray alloc] init];
		addedFiles = [[NSMutableArray alloc] init];
		removedFiles = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc
{
	if(date!=nil){
		[date release];
	}
	if(message!=nil){
		[message release];
	}
	if(type!=nil){
		[type release];
	}
	if(filename!=nil){
		[filename release];
	}
	if(user!=nil){
		[user release];
	}
	if(kind!=nil){
		[kind release];
	}
    if(revision!=nil){
		[revision release];
	}
	
	[modifiedFiles release];
	[addedFiles release];
	[removedFiles release];
	
	[super dealloc];
}


@end
