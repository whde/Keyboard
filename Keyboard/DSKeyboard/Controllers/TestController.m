//
//  TestController.m
//  Keyboard
//
//  Created by Whde on 19/3/5.
//  Copyright © 2019年 Whde. All rights reserved.
//

#import "TestController.h"
#import "ELKyeboard.h"
#include <objc/runtime.h>
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
// home indicator

@interface TestController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *tf0;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) ELKyeboard * keyboard;
@property (nonatomic, strong) UILabel *msg;
@end

@implementation TestController

#pragma mark - lazy loading
- (UITextField *)tf0 {
    if (!_tf0) {
        _tf0 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 100, kScreenWidth - 2 * 20, 30)];
        _tf0.delegate = self;
        [_tf0 addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
        _tf0.borderStyle = UITextBorderStyleRoundedRect;
        _tf0.backgroundColor = [UIColor whiteColor];
        _tf0.placeholder = @"请输入账号";
    }
    return _tf0;
}

- (UITextField *)tf {
    if (!_tf) {
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tf0.frame) + 20, kScreenWidth - 2 * 20, 30)];
        _tf.delegate = self;
        _tf.borderStyle = UITextBorderStyleRoundedRect;
        _tf.backgroundColor = [UIColor whiteColor];
        _tf.placeholder = @"请输入密码";
    }
    return _tf;
}
- (UILabel *)msg {
    if (!_msg) {
        _msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 30)];
        _msg.textColor = [UIColor redColor];
        _msg.textAlignment = NSTextAlignmentCenter;
    }
    return _msg;
}


#pragma mark - loading view
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_tf0 becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tf0];
    [self.view addSubview:self.tf];
    [self.view addSubview:self.msg];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setupCustomedKeyboard:textField];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.tf) {
        [(ELKyeboard *)self.tf.inputView clear];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (ELKyeboard *)keyboard {
    if (!_keyboard) {
        _keyboard = [ELKyeboard keyboard];
        __weak typeof(self) weakSelf = self;
        [_keyboard setReturnKey:@"下一题" handler:^(UITextField*tf){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf next];
        }];
        [_keyboard setOutputBlock:^(UITextField*tf, NSString *text) {
            tf.text = text;
        }];
        [_keyboard setToolBarBlock:^UIView *{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, strongSelf.view.frame.size.width, 44)];
            NSDictionary *attriDic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:16],NSForegroundColorAttributeName:[UIColor blackColor]};
            UIButton *last = [UIButton buttonWithType:UIButtonTypeCustom];
            NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"上一题" attributes:attriDic];
            last.frame = CGRectMake(0, 0, 60, 44);
            [last setAttributedTitle:attri forState:UIControlStateNormal];
            [last addTarget:strongSelf action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *lastItem = [[UIBarButtonItem alloc] initWithCustomView:last];
            
            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
            NSAttributedString *nextAttri = [[NSAttributedString alloc] initWithString:@"下一题" attributes:attriDic];
            next.frame = CGRectMake(0, 0, 60, 44);
            [next setAttributedTitle:nextAttri forState:UIControlStateNormal];
            [next addTarget:strongSelf action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithCustomView:next];
            
            toolBar.items = @[lastItem, spaceItem, nextItem];
            return toolBar;
        }];
    }
    return _keyboard;
}
- (void)setupCustomedKeyboard:(UITextField *)textField {
    textField.inputView = self.keyboard;
    [(ELKyeboard *)textField.inputView resetWithTextField:textField];
    if (textField == _tf0) {
        [(ELKyeboard *)textField.inputView setReturnKey:@"下一题" handler:^(UITextField *tf) {
            [self next];
        }];
    } else {
        [(ELKyeboard *)textField.inputView setReturnKey:@"提交" handler:^(UITextField *tf) {
            [self submit];
        }];
    }
}

- (void)last {
    [_tf0 becomeFirstResponder];
}
- (void)next {
    [_tf becomeFirstResponder];
}
- (void)submit {
    self.msg.text = @"提交完成";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.msg.text = @"";
    });
}
@end
