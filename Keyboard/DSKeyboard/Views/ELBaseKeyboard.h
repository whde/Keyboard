//
//  ELBaseKeyboard.h
//  Keyboard
//
//  Created by Whde on 19/4/25.
//  Copyright © 2019年 Whde. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKeyboardButtonFont 25
#define kButtonCornerRadius 5

typedef void(^KeyboardInput)(NSString *text);

@interface ELBaseKeyboard : UIView

@property (nonatomic, copy) KeyboardInput kbInput;
@property (nonatomic, strong) UIColor *kbBackgroundColor;
@property (nonatomic, strong) UIColor *kbButtonSelectedColor;

- (void)getDSKeyboardInputWithInput:(KeyboardInput)kbInput;

@end
