//
//  ViewController.h
//  encke_ios
//
//  Created by Michael on 14/12/2.
//  Copyright (c) 2014年 MichealXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK/Headers/ZBarSDK/ZBarSDK.h"

@interface ViewController : UIViewController <ZBarReaderDelegate>{
    IBOutlet UITextField *txt_username;
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_loginUrl;
    IBOutlet UIButton *btn_scan;
    IBOutlet UIButton *btn_login;
}

-(IBAction) backgroupTap:(id)sender;
-(IBAction) textDoneEditing:(id)sender;
-(IBAction) scan:(id)sender;
-(IBAction) login:(id)sender;

@end
