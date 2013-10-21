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
#import "ChangeSetXmlDataParser.h"

@implementation ChangeSetXmlDataParser

@synthesize  currentEditType;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
	
	if([elementName isEqualToString:@"item"]){
		
		currentSubObject = [[HudsonChange alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName isEqualToString:@"date"]){
		
		;
	}else if([elementName isEqualToString:@"msg"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setMessage:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"user"] || [elementName isEqualToString:@"fullName"]){
		if(currentSubObject!=nil){
			[currentSubObject setUser:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"editType"]){
		
        [self setCurrentEditType:currentReadCharacters];
        
	}else if([elementName isEqualToString:@"file"]){
		if(currentSubObject!=nil){
			
            if([currentEditType isEqualToString:@"edit"]){
            
                [[(HudsonChange*)currentSubObject modifiedFiles] addObject:currentReadCharacters];
                
            }else if([currentEditType isEqualToString:@"add"]){

                [[(HudsonChange*)currentSubObject addedFiles] addObject:currentReadCharacters];
            }else if([currentEditType isEqualToString:@"delete"]){
                
                [[(HudsonChange*)currentSubObject removedFiles] addObject:currentReadCharacters];
            }
            
		}
	}else if([elementName isEqualToString:@"merge"]){
		if(currentSubObject!=nil){
			[currentSubObject setMerge:[currentReadCharacters isEqualToString:@"true"]];
		}
	}else if([elementName isEqualToString:@"revision"] || [elementName isEqualToString:@"rev"]||
             [elementName isEqualToString:@"id"]){
		
		if(currentSubObject!=nil){
			[currentSubObject setRevision:currentReadCharacters];
		}
	}else if([elementName isEqualToString:@"kind"]){
		
		[currentObject setKind:currentReadCharacters];
	}else if([elementName isEqualToString:@"item"]){
		
		[[currentObject changeList] addObject:currentSubObject];
		currentSubObject = nil;
	}
}

@end
