//
//  ELLetterKeyboard.m
//  Keyboard
//
//  Created by Whde on 19/4/24.
//  Copyright © 2019年 Whde. All rights reserved.
//

#import "ELLetterKeyboard.h"
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define def_currentMode_size [[UIScreen mainScreen] currentMode].size
#define def_currentMode_equal(width, height) \
CGSizeEqualToSize(CGSizeMake(width, height), def_currentMode_size)
#define COORDINATE_x_SCALE(x) (SCREEN_WIDTH*x/375.0)
#define iPhoneX     def_currentMode_equal(1125, 2436)
#define iPhoneXR    def_currentMode_equal(828,  1792)
#define iPhoneXS    def_currentMode_equal(1125, 2436)
#define iPhoneXSMax def_currentMode_equal(1242, 2688)
#define def_Bang (iPhoneX || iPhoneXR || iPhoneXS || iPhoneXSMax)
#define HOME_INDICATOR_HEIGHT (def_Bang ? 34.f : 0.f)

@interface ELKeyboardButton : UIButton
@property (nonatomic, copy) NSString *text;
@end
@implementation ELKeyboardButton
@end

@interface ELLetterKeyboard ()

@property (nonatomic, strong) NSArray *lowercases;
@property (nonatomic, strong) NSArray *uppercases;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ELLetterKeyboard
- (void)setReturnKey:(NSString *)returnKey {
    _returnKey = returnKey;
    [self reloadTitleIndex:[self.lowercases indexOfObject:@"return"] obj:@"return"];
}

- (NSArray *)lowercases {
    if (!_lowercases) {
        _lowercases = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"shift", @"z", @"x", @"c", @"v", @"b", @"n", @"m", @"delete",@"-",@"'", @"空格", @"return"];
    }
    return _lowercases;
}

- (NSArray *)uppercases {
    if (!_uppercases) {
        _uppercases = @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"shift", @"Z", @"X", @"C", @"V", @"B", @"N", @"M", @"delete",@"-",@"'", @"空格", @"return"];
    }
    return _uppercases;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = self.kbBackgroundColor;
        self.returnKey = @"return";
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    ELKeyboardButton *lastBtn = nil;
    for (NSInteger i=0; i<self.lowercases.count; i++) {
        NSString *obj = self.lowercases[i];
        ELKeyboardButton *btn = [ELKeyboardButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = kButtonCornerRadius;
        [btn addTarget:self action:@selector(letterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.35].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0,1);
        btn.layer.shadowOpacity = 1;
        btn.layer.shadowRadius = 0;
        btn.tag = i+200;
        btn.text = obj;
        [self addSubview:btn];
        if (i<10) {
            if ([obj.lowercaseString isEqual:@"q"]) {
                btn.frame = CGRectMake(COORDINATE_x_SCALE(3), COORDINATE_x_SCALE(10), COORDINATE_x_SCALE(31.5), COORDINATE_x_SCALE(42));
            } else {
                CGRect rect = lastBtn.frame;
                rect.origin.x = CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(6);
                btn.frame = rect;
            }
            lastBtn = btn;
        } else if (i<19) {
            if ([obj.lowercaseString isEqual:@"a"]) {
                btn.frame = CGRectMake(COORDINATE_x_SCALE(21.75), CGRectGetMaxY(lastBtn.frame)+COORDINATE_x_SCALE(12), COORDINATE_x_SCALE(31.5), COORDINATE_x_SCALE(42));
            } else {
                CGRect rect = lastBtn.frame;
                rect.origin.x = CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(6);
                btn.frame = rect;
            }
            lastBtn = btn;
        } else if (i<28) {
            if ([obj isEqual:@"shift"]) {
                btn.frame = CGRectMake(COORDINATE_x_SCALE(3), CGRectGetMaxY(lastBtn.frame)+COORDINATE_x_SCALE(12), COORDINATE_x_SCALE(42), COORDINATE_x_SCALE(42));
            } else if ([obj isEqual:@"delete"]) {
                btn.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(14.25), CGRectGetMinY(lastBtn.frame), COORDINATE_x_SCALE(42), COORDINATE_x_SCALE(42));
            } else {
                if ([obj.lowercaseString isEqual:@"z"]) {
                    btn.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(14.25), CGRectGetMinY(lastBtn.frame), COORDINATE_x_SCALE(31.5), COORDINATE_x_SCALE(42));
                } else {
                    CGRect rect = lastBtn.frame;
                    rect.origin.x = CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(6);
                    btn.frame = rect;
                }
            }
            lastBtn = btn;
        } else {
            if ([obj isEqual:@"-"]) {
                btn.frame = CGRectMake(COORDINATE_x_SCALE(3), CGRectGetMaxY(lastBtn.frame)+COORDINATE_x_SCALE(10), COORDINATE_x_SCALE(41), COORDINATE_x_SCALE(42));
            } else if ([obj isEqual:@"'"]) {
                btn.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(6), CGRectGetMinY(lastBtn.frame), COORDINATE_x_SCALE(41), COORDINATE_x_SCALE(42));
            } else if ([obj isEqual:@"空格"]) {
                btn.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(6), CGRectGetMinY(lastBtn.frame), COORDINATE_x_SCALE(180), COORDINATE_x_SCALE(42));
            } else {
                btn.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(6), CGRectGetMinY(lastBtn.frame), SCREEN_WIDTH-(CGRectGetMaxX(lastBtn.frame)+COORDINATE_x_SCALE(9)), COORDINATE_x_SCALE(42));
            }
            lastBtn = btn;
        }
    }
    CGRect rect = self.frame;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = CGRectGetMaxY(lastBtn.frame)+COORDINATE_x_SCALE(4)+HOME_INDICATOR_HEIGHT;
    self.frame = rect;
    [self loadBtnTitleWithTitles:self.lowercases];
}

- (void)reloadTitleIndex:(NSUInteger)idx obj:(id _Nonnull)obj {
    ELKeyboardButton *btn = (ELKeyboardButton *)[self viewWithTag:200 + idx];
    btn.text = obj;
    if ([obj isEqual:@"shift"]) {
        if (btn.selected) {
            btn.backgroundColor = [UIColor whiteColor];
            [btn setImage:[UIImage imageNamed:@"Shift"] forState:UIControlStateNormal];
        } else {
            btn.backgroundColor = [UIColor colorWithRed:169/255.0 green:175/255.0 blue:185/255.0 alpha:1];
            [btn setImage:[UIImage imageNamed:@"Shift_1"] forState:UIControlStateNormal];
        }
        [btn setTitle:@"" forState:UIControlStateNormal];
    } else if ([obj isEqual:@"delete"]) {
        btn.backgroundColor = [UIColor colorWithRed:169/255.0 green:175/255.0 blue:185/255.0 alpha:1];
        [btn setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMore:)];
        longPress.minimumPressDuration = 0.8;
        [btn addGestureRecognizer:longPress];
    } else if ([obj isEqual:@"-"] || [obj isEqual:@"'"]) {
        btn.backgroundColor = [UIColor colorWithRed:169/255.0 green:175/255.0 blue:185/255.0 alpha:1];
        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:self.kbButtonSelectedColor forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:kKeyboardButtonFont];
        [btn setTitle:obj forState:UIControlStateNormal];
    } else if ([obj isEqual:@"空格"]) {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:self.kbButtonSelectedColor forState:UIControlStateHighlighted];
        [btn setTitle:obj forState:UIControlStateNormal];
    } else if ([obj isEqual:@"return"]) {
        btn.backgroundColor = [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1.0];
        [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:self.kbButtonSelectedColor forState:UIControlStateHighlighted];
        [btn setTitle:self.returnKey forState:UIControlStateNormal];
    } else {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:self.kbButtonSelectedColor forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:kKeyboardButtonFont];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(letterButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)loadBtnTitleWithTitles:(NSArray *)titles {
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self reloadTitleIndex:idx obj:obj];
    }];
}

- (void)letterButtonTouchDown:(ELKeyboardButton *)btn {

}

- (void)deleteMore:(UILongPressGestureRecognizer*)sender {
    if (sender.state ==UIGestureRecognizerStateBegan) {
        [self beginDelete:(ELKeyboardButton *)sender.view];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self endDelete];
    }
}
- (void)beginDelete:(ELKeyboardButton *)btn {
    [self.timer invalidate];
    self.timer =nil;
    self.timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *_Nonnull timer) {
        [self letterButtonClick:btn];
    }];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)endDelete {
    [self.timer invalidate];
    self.timer =nil;
}

- (void)letterButtonClick:(ELKeyboardButton *)btn {
    if ([btn.text isEqual:@"shift"]) {
        btn.selected = !btn.selected;
        [self loadBtnTitleWithTitles:btn.selected ? self.uppercases : self.lowercases];
    } else {
        NSString *text = btn.text;
        if ([text isEqual:@"空格"]) {
            text = @" ";
        }
        if (self.kbInput) {
            self.kbInput(text);
        }
    }
}

- (void)getDSKeyboardInputWithInput:(KeyboardInput)kbInput {
    self.kbInput = kbInput;
}

@end
