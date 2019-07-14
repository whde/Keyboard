//
//  ELBaseKeyboard.m
//  Keyboard
//
//  Created by Whde on 19/4/25.
//  Copyright © 2019年 Whde. All rights reserved.
//

#import "ELBaseKeyboard.h"

@implementation ELBaseKeyboard

- (UIColor *)kbBackgroundColor {
    if (!_kbBackgroundColor) {
        _kbBackgroundColor = [UIColor colorWithRed:210 / 255.0 green:213 / 255.0 blue:218 / 255.0 alpha:1.0];
    }
    return _kbBackgroundColor;
}

- (UIColor *)kbButtonSelectedColor {
    if (!_kbButtonSelectedColor) {
        _kbButtonSelectedColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _kbButtonSelectedColor;
}

- (void)getDSKeyboardInputWithInput:(KeyboardInput)kbInput {}

@end
