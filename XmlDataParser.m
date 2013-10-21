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

#import "XmlDataParser.h"

@implementation XmlDataParser

@synthesize onLoadFinisched;
@synthesize  caller;

-(id)initWithCaller:(id)_caller andObjectToStore:(id)object{

	if(self = [super init]){
	
		caller = _caller;
		currentObject = object;
	}
	
	return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
	
	//do nothing
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	
	if(currentReadCharacters == nil){
		
		currentReadCharacters = [[[NSMutableString alloc] initWithString:string] retain];
	}else{
		
		[currentReadCharacters appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{

	[caller performSelector:onLoadFinisched];
}

@end
