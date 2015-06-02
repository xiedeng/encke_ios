//
//  ScannerController.h
//  encke_ios
//
//  Created by Michael on 15/5/5.
//  Copyright (c) 2015年 MichealXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK/Headers/ZBarSDK/ZBarSDK.h"

@interface ScannerController : UIViewController<ZBarReaderDelegate>{
    UIView *_QrCodeline;
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
    UINavigationItem *navigationItem;
    int width;
}

@end
