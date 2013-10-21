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

#import "InputTableViewCell3.h"


@implementation InputTableViewCell3

@synthesize textField, parent, inputCellUpdateSelector,startEditingSel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if(parent!=nil && startEditingSel!=nil){
        
        [parent performSelector:startEditingSel withObject:textField];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if(parent!=nil && inputCellUpdateSelector!=nil){
    
        [parent performSelector:inputCellUpdateSelector withObject:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
