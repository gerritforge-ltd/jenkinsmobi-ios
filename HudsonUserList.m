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
#import "HudsonUserList.h"

@implementation HudsonUserList

@synthesize userList, filter;

-(id)init{
    
    self = [super init];
    
	if(self){
		
        userList = [[NSMutableArray alloc] init];

		[self setUrl:[NSString stringWithFormat:@"%@/people",[[Configuration getInstance] url]]];
        
//        [self setXPathQueryString:[QueryStringNormalizer normalize:[NSString stringWithFormat:@"xpath=/people/user[position()<=%d]/user&wrapper=users",[[Configuration getInstance] maxBuildsNumberToLoadAtTime]]]];
        
        [self setXPathQueryString:[QueryStringNormalizer normalize:[NSString stringWithFormat:@"xpath=/people/user/user&wrapper=users"]]];
        
        xmlDataParser = [[UserListXmlDataParser alloc] initWithCaller:self andObjectToStore:self];
    }
	
	return self;
}

-(void)loadHudsonObject{

    [userList removeAllObjects];
    [super loadHudsonObject];
}

-(void)loadNextUsers:(int)moreUsers{

    
}

-(NSMutableArray*)userList{

	
	NSMutableArray* result = nil;
	
	if(filter==nil || [filter isEqualToString:@"all"]){
		
		result = userList;
        
	}else{
    
        filteredUserList = [[[NSMutableArray alloc] init] autorelease];
        
        for (HudsonUser* user in userList) {
            
            if([[user name] rangeOfString:filter options:NSCaseInsensitiveSearch].location!=NSNotFound){
                
                [filteredUserList addObject:user];
            }
        }
		
		result =  filteredUserList;
	}
	
	return result;
}

- (void) dealloc
{
    [userList release];
	[super dealloc];
}

@end
