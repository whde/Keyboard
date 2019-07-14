//
//  AppDelegate.m
//  Keyboard
//
//  Created by Whde on 19/3/5.
//  Copyright © 2019年 Whde. All rights reserved.
//

#import "AppDelegate.h"
#import "TestController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[TestController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end
