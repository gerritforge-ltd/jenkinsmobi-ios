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

#import "QueryStringNormalizer.h"

@implementation QueryStringNormalizer

+(NSString*)normalize:(NSString*)queryString{
	
	int len = [queryString length];
	const char* chBuffer = [queryString cStringUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableString* result = [[[NSMutableString alloc] init] autorelease];
	
	/*
	 / --> 0x2F
	 * --> 0x2A
	 & --> 0x26
	 | --> 0x7C
	 ' --> 0x27
     < --> 0x3C
     > --> 0x3E
	 */
	
	for (int i = 0; i < len; i++) {
		
		char ch = chBuffer[i];
		switch (ch) {
			case 0x2F:
				[result appendString:@"%2F"];
				break;
			case 0x2A:
				[result appendString:@"%2A"];			
				break;
			//case 0x26:
			//	[result appendString:@"%26"];			
			//	break;
			case 0x7C:
				[result appendString:@"%7C"];
				break;
			case 0x20:
				[result appendString:@"%20"];
				break;
			case 0x27:
				[result appendString:@"%27"];
				break;		
			case 0x3C:
				[result appendString:@"%3C"];
				break;		
			case 0x3E:
				[result appendString:@"%3E"];
				break;		
			default:
				[result appendString:[NSString stringWithFormat:@"%c",ch]];
				break;
		}
	}

	return result;
}

+(NSString*)normalizeBlanks:(NSString*)queryString{
	
	int len = [queryString length];
	const char* chBuffer = [queryString cStringUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableString* result = [[[NSMutableString alloc] init] autorelease];
	
	for (int i = 0; i < len; i++) {
		
		char ch = chBuffer[i];
		switch (ch) {
			case 0x20:
				[result appendString:@"%20"];
				break;
			default:
				[result appendString:[NSString stringWithFormat:@"%c",ch]];
				break;
		}
	}
	
	return result;
}

@end
