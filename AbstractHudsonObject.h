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
#import "SimpleHTTPGetter.h"
#import "IWSDataReceiver.h"
#import "XmlDataParser.h"
#import "QueryStringNormalizer.h"
#import "Configuration.h"
#import "Logger.h"

/*
	Ths object sends onLoadFinischedWithErrors and onLoadFinisched to nofity parent that data has been loaded and the object is ready 
	to be used in the app.
 
	This class MUST be subclassed by EVERY business object of HudsonMobi app
 
	Note that if you will find that sub-classes have any others common fields ADD them in this class
 */

@interface AbstractHudsonObject : NSObject <IWSDataReceiver> {

	id<IWSDataReceiver> delegate;
	NSString* description;
	NSString* name;
	NSString* displayName;
	NSString* url;
	NSString* xPathQueryString;
	NSString* colorName;
	SimpleHTTPGetter* httpGetter;
	XmlDataParser* xmlDataParser;
	bool silentMode;
	
	NSData* downloadedData;
}

@property (assign) bool silentMode;
@property (nonatomic, retain) id delegate;
@property (copy) NSString* name;
@property (copy) NSString* displayName;
@property (copy) NSString* url;
@property (copy) NSString* colorName;
@property (copy) NSString* description;
@property (copy) NSString* xPathQueryString;

-(void)loadHudsonObject;

-(void)stopLoad;

@end
