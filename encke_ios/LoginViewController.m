//
//  LoginViewController.m
//  encke_ios
//
//  Created by Michael on 15/3/27.
//  Copyright (c) 2015年 MichealXie. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpUtils.h"
#import "JsonUtils.h"
#import "LoginInfo.h"
#import "User.h"
#import "RootViewController.h"
#import "ScannerController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    txt_password.secureTextEntry = YES;
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars"]]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [super viewDidLoad];
    [self initInfo];
}

- (void) initInfo{
    
}

- (void) initUserInfo
{
    NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    NSString* loginUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginUrl"];
    txt_username.text = username;
    txt_password.text = password;
    txt_loginUrl.text = loginUrl;
    [self loginSystem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) backgroupTap:(id)sender
{
    [txt_username resignFirstResponder];
    [txt_password resignFirstResponder];
    [txt_loginUrl resignFirstResponder];
}

-(IBAction) textDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction) scan:(id)sender
{
    ScannerController *scanner = [ScannerController new];
    [self presentModalViewController:scanner animated:YES];
    scanner.block = ^(NSString *str){
            NSArray *infos = [str componentsSeparatedByString:@"|"];
            if (infos == nil || [infos count] != 2) {
                return;
            }
            txt_loginUrl.text = [infos objectAtIndex:0];
            txt_username.text = [infos objectAtIndex:1];
    };
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
//    ZBarSymbol * symbol;
//    for(symbol in results)
//        break;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSString *str = symbol.data;
//    NSArray *infos = [str componentsSeparatedByString:@"|"];
//    if (infos == nil || [infos count] != 2) {
//        return;
//    }
//    txt_loginUrl.text = [infos objectAtIndex:0];
//    txt_username.text = [infos objectAtIndex:1];
    
}

-(void) showAlert:(NSString *) message
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertview show];
}

-(void) loginSystem
{
    NSString *loginUrl = [txt_loginUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *username = [txt_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [txt_password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"%@/api/login?username=%@&password=%@",loginUrl,username,password];
    if ([username isEqual: @""]) {
        [self showAlert:@"用户名不能为空"];
        return;
    }
    if ([password isEqual: @""]) {
        [self showAlert:@"密码不能为空"];
        return;
    }
    if ([loginUrl isEqual: @""]) {
        [self showAlert:@"登录地址不能为空"];
        return;
    }
    NSData *data = [HttpUtils syncHttpGet:url];
    NSError *error = nil;
    if (data == nil) {
        [self showAlert:@"登录失败"];
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
    }else{
        [self showAlert:@"用户名或密码错误"];
    }
}

-(IBAction) login:(id)sender
{
    [self loginSystem];
}

@end
