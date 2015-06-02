//
//  LoadingViewController.m
//  encke_ios
//
//  Created by Michael on 15/3/27.
//  Copyright (c) 2015年 MichealXie. All rights reserved.
//

#import "LoadingViewController.h"
#import "HttpUtils.h"
#import "JsonUtils.h"
#import "LoginInfo.h"
#import "User.h"
#import "RootViewController.h"
#import "LoginViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Loading"]]];
    [self initUserInfo];
}

- (void) initUserInfo
{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loginSystem) userInfo:nil repeats:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [myTimer setFireDate:[NSDate distantFuture]];
    //取消定时器
    [myTimer invalidate];
}

-(void) loginSystem
{
    NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    NSString* loginUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginUrl"];
    NSString *url = [NSString stringWithFormat:@"%@/api/login?username=%@&password=%@",loginUrl,username,password];
    if ([username isEqual: @""] || [password isEqual: @""] || [loginUrl isEqual: @""]) {
        [self jumpLoginForm];
        return;
    }
    NSData *data = [HttpUtils syncHttpGet:url];
    NSError *error = nil;
    if (data == nil) {
        [self jumpLoginForm];
        return;
    }
    NSDictionary *rootDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    LoginInfo* loginInfo = [[LoginInfo alloc] init];
    for (NSString *key in rootDIC) {
        [loginInfo setValue:[rootDIC objectForKey:key] forKey:key];
    }
    if (loginInfo.success) {
        // 存储数据
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:loginUrl forKey:@"loginUrl"];
        // Override point for customization after application launch.Ui
        RootViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
        [self presentModalViewController:rootViewController animated:YES];
        //返回
        [self dismissModalViewControllerAnimated:YES];
        
    }else{
        [self jumpLoginForm];
    }
}

- (void)jumpLoginForm {
    LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
    [self presentModalViewController:loginView animated:YES];
    //返回
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
