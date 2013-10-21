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

@interface HudsonQueueItem : AbstractHudsonObject {

	BOOL blocked;
	BOOL buildable;
	BOOL stuck;
	NSString* reasonInQueue;
	NSString* shortDescription;
	long buildableStartMilliseconds;
}

@property (assign) BOOL blocked;
@property (assign) BOOL buildable;
@property (assign) BOOL stuck;
@property (copy) NSString* reasonInQueue;
@property (copy) NSString* shortDescription;
@property (assign) long buildableStartMilliseconds;

@end
