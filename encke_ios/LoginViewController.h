//
//  LoginViewController.h
//  encke_ios
//
//  Created by Michael on 15/3/27.
//  Copyright (c) 2015年 MichealXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{
    IBOutlet UITextField *txt_username;
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_loginUrl;
    IBOutlet UIButton *btn_scan;
    IBOutlet UIButton *btn_login;
    NSTimer *timer;

}

-(IBAction) backgroupTap:(id)sender;
-(IBAction) textDoneEditing:(id)sender;
-(IBAction) scan:(id)sender;
-(IBAction) login:(id)sender;

@end
