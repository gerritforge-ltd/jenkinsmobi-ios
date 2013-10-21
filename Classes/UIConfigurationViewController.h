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

#import <UIKit/UIKit.h>
#import "Configuration.h"
#import "MultiChoiceTableViewCell.h"
#import "InputTableViewCell3.h"
#import "InputTableViewCell4.h"
#import "OnOffTableViewCell3.h"
#import "AlertPrompt.h"

@class ConfigurationObject;
@class ConfigurationObjectTester;
@class LoadingView;

@interface UIConfigurationViewController : UITableViewController {

	NSArray* configurationItems;
	
    NSMutableArray* cellValues;
    UITextField* currentEditingTextField;
    
    
	ConfigurationObject* currentConfigurationObject;
	ConfigurationObject* testConfigurationObject;
	ConfigurationObjectTester* confTester;
	int oldSelectedConfigurationObject;
	LoadingView* loadingView;
	bool testingConnection;
	UITableViewCell* previewCellToUpdate;
}

@property (nonatomic,retain) UITextField* currentEditingTextField;

-(IBAction)saveClick:(id)sender;

-(IBAction)cancelClick:(id)sender;

-(IBAction)trashClick:(id)sender;

-(IBAction)testClick:(id)sender;

-(id)initWithNibName:(NSString*)nib bundle:(NSBundle*)bunble andConfigurationObject:(ConfigurationObject*)confObject;

@end
