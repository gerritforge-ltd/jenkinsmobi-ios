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

#import "MultiChoiceTableViewCell.h"
#import "ChoiceTableViewController.h"

@implementation MultiChoiceTableViewCell

@synthesize parentNavController, choiceViewTitle, value, choiceViewPrompt;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
		editingEnabled = YES;
		choiceList = [[NSMutableArray alloc] init];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

-(void)addChoice:(NSString*)newChoice{

	[choiceList addObject:newChoice];
}

-(void)setValue:(NSString*)_value{
	
	value = _value;
	[[self detailTextLabel] setText:value];
	
	[self setNeedsLayout];
}


-(void)setUserInteractionEnabled:(BOOL)enabled{
	
	editingEnabled = enabled;
	
	if(editingEnabled){
		[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}else{
		[self setAccessoryType:UITableViewCellAccessoryNone];
	}
	
	[self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

	if(highlighted==YES && editingEnabled==YES){
		
		if(parentNavController!=nil){
			
			ChoiceTableViewController *anotherViewController = [[ChoiceTableViewController alloc] initWithStyle:UITableViewStyleGrouped andChoices:choiceList andTitle:choiceViewTitle];
			[anotherViewController setSelectedChoice:value];
			[anotherViewController setDelegate:self];
			[[anotherViewController navigationItem] setPrompt:choiceViewPrompt];
			[parentNavController pushViewController:anotherViewController animated:YES];
			[anotherViewController release];
			
		}else{
		
			NSLog(@"ERROR: parentNavController not set!!!");
		}
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
