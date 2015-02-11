//
//  ViewController.m
//  encke_ios
//
//  Created by Michael on 14/12/2.
//  Copyright (c) 2014年 MichaelTse. All rights reserved.
//

#import "ViewController.h"
#import "HttpUtils.h"
#import "JsonUtils.h"
#import "LoginInfo.h"
#import "User.h"
#import "RootViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    txt_password.secureTextEntry = YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars"]]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [super viewDidLoad];
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
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    reader.showsZBarControls = YES;
    
    [self presentViewController:reader animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *str = symbol.data;
    NSArray *infos = [str componentsSeparatedByString:@"|"];
    if (infos == nil || [infos count] != 2) {
        return;
    }
    txt_loginUrl.text = [infos objectAtIndex:0];
    txt_username.text = [infos objectAtIndex:1];
    
}

-(void) showAlert:(NSString *) message
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertview show];
}

-(IBAction) login:(id)sender
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
        // Override point for customization after application launch.Ui
        RootViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
        [self presentModalViewController:rootViewController animated:YES];        
        //返回
        [self dismissModalViewControllerAnimated:YES];
       
    }else{
        [self showAlert:@"用户名或密码错误"];
    }

    
}

@end
