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

#import "AlertPrompt.h"

@implementation AlertPrompt
@synthesize textField;
@synthesize secureTextEntry;
@synthesize prompt;
@synthesize keyboardType;
@synthesize autoCapitalize;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
	
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0f, 50.0f, 260.0f, 25.0f)];
        [theTextField setBackgroundColor:[UIColor whiteColor]];
		[theTextField setAlpha:1.f];
		[theTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
		
		if([[Configuration getInstance] iOSVersion] < 4){ //workaround to avoid the message box to fly high in the screen ;)
			
			//CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
			//[self setTransform:translate];
		}
		
		autoCapitalize = NO;
    }
    return self;
}

-(void)setSecureTextEntry:(bool)_secure{

	secureTextEntry = _secure;

	if(_secure){
		
		[textField setSecureTextEntry:YES];
	}
}

-(void)setKeyboardType:(int)kbtype{
	
	keyboardType = kbtype;
	
	switch (keyboardType) {
		case 0:
			// leave the default
			break;
		case 1:
			[textField setKeyboardType:UIKeyboardTypeNumberPad];
			break;
		case 2:
			[textField setKeyboardType:UIKeyboardTypeURL];
			break;			
		default:
			break;
	}
	
	if(autoCapitalize==NO){
		[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	}
}

-(void)setPrompt:(NSString*)_prompt{

	prompt = _prompt;
	
	[textField setText:prompt];
}

- (void)show{
	
    [super show];
	
	[textField becomeFirstResponder];
}

- (NSString *)enteredText{
	
    return textField.text;
}

- (void)dealloc
{
    [textField release];
    [super dealloc];
}
@end