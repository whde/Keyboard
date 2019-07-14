//
//  ELKyeboard.h
//  Keyboard
//
//  Created by Whde on 19/4/24.
//  Copyright © 2019年 Whde. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KeyboardOutput)(UITextField*tf, NSString *text);
typedef UIView *(^KeyboardToolBar)(void);
typedef void (^KeyboardReturnKeyHandler)(UITextField*tf);

@interface ELKyeboard : UIView

@property (nonatomic, copy) KeyboardOutput outputBlock;
@property (nonatomic, copy) KeyboardToolBar toolBarBlock;

- (void)setReturnKey:(NSString *)returnKey handler:(KeyboardReturnKeyHandler)handler;
+ (instancetype)keyboard;
- (void)resetWithTextField:(UITextField *)tf;
- (void)clear;

@end

/*
 toolBar 背景色 235 237 239
        字体 白色
        选中 蓝色
 键盘 背景色 210 213 218
 按键 背景色 白色
 按键字体色 黑色
 特殊按键 背景色 174 179 188
*/
