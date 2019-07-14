//
//  ELKyeboard.m
//  Keyboard
//
//  Created by Whde on 19/4/24.
//  Copyright © 2019年 Whde. All rights reserved.
//

#import "ELKyeboard.h"
#import "ELLetterKeyboard.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ELKyeboard ()
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) ELLetterKeyboard *letterKB;
@property (nonatomic, copy) NSString *output;

@property (nonatomic, copy) NSString *returnKey;
@property (nonatomic, copy) KeyboardReturnKeyHandler returnKeyHandler;

@end

@implementation ELKyeboard
#pragma mark - lazy loading
- (UIView *)letterKB {
    if (!_letterKB) {
        _letterKB = [[ELLetterKeyboard alloc] init];
    }
    return _letterKB;
}

- (NSString *)output {
    if (!_output) {
        _output = [NSString string];
    }
    return _output;
}


+ (instancetype)keyboard {
    return [[ELKyeboard alloc] init];
}
- (instancetype)init {
    if (self = [super init]) {
        [self editingData];
    }
    return self;
}

- (void)resetWithTextField:(UITextField *)tf {
    self.tf = tf;
    self.output = self.tf.text;
}

- (void)editingData {
    __weak typeof(self) weakSelf = self;
    [(ELLetterKeyboard *)self.letterKB getDSKeyboardInputWithInput:^(NSString *text){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf outputByText:text];
    }];
    [self addSubview:self.letterKB];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.letterKB.frame));
}

- (void)setToolBarBlock:(KeyboardToolBar)toolBarBlock {
    _toolBarBlock = toolBarBlock;
    self.toolBar = _toolBarBlock();
    [self addSubview:self.toolBar];
    CGRect rect = _letterKB.frame;
    rect.origin.y = CGRectGetMaxY(self.toolBar.frame);
    _letterKB.frame = rect;
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.letterKB.frame));
}

- (void)setReturnKey:(NSString *)returnKey handler:(KeyboardReturnKeyHandler)handler {
    _returnKey = returnKey;
    _returnKeyHandler = handler;
    self.letterKB.returnKey = returnKey;
}

- (void)outputByText:(NSString *)text {
    if ([text isEqual:@"return"]) {
        if (_returnKeyHandler) {
            _returnKeyHandler(self.tf);
        }
        return;
    } else if ([text isEqual:@"delete"]) {
        if (self.output.length >= 2) {
            self.output = [self.output substringToIndex:self.tf.text.length - 1];
        } else {
            self.output = nil;
        }
    } else {
        self.output = [self.output stringByAppendingString:text];
    }
    if (self.outputBlock) {
        self.outputBlock(self.tf, self.output);
    }
}
- (void)clear {
    self.output = nil;
}

- (void)dealloc {
    self.output = nil;
}

@end
