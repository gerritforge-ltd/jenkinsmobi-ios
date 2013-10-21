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

#import "HudsonTestXmlDataParser.h"

@implementation HudsonTestXmlDataParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName isEqualToString:@"errorDetails"]){
		
        [currentObject setErrorDetails:currentReadCharacters];
	}else if([elementName isEqualToString:@"errorStackTrace"]){
		
        [currentObject setErrorStackTrace:currentReadCharacters];
	}else if([elementName isEqualToString:@"stderr"]){
		
        [currentObject setErrorStdOut:currentReadCharacters];
	}else if([elementName isEqualToString:@"stdout"]){
		
        [currentObject setErrorStdErr:currentReadCharacters];
	}
}

@end
