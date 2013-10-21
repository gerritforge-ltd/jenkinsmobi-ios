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

@class UserXmlDataParser;

@interface HudsonUser : AbstractHudsonObject {

	NSString* projectName;
	NSString* projectUrl;
	NSString* mailAddress;
	NSString* userId;
	long lastChange;
}

@property (copy) NSString* projectName;
@property (copy) NSString* projectUrl;
@property (copy) NSString* mailAddress;
@property (copy) NSString* userId;
@property (assign) long lastChange;

@end
