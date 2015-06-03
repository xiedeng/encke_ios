//
//  ScannerController.m
//  encke_ios
//
//  Created by Michael on 15/5/5.
//  Copyright (c) 2015年 MichealXie. All rights reserved.
//

#import "ScannerController.h"
#import "LoginViewController.h"

#define VIEW_WIDTH   320
#define VIEW_HEIGHT  582
#define SCANVIEW_EdgeTop 80
#define SCANVIEW_EdgeLeft 40
#define TINTCOLOR_ALPHA 0.3
#define DARKCOLOR_ALPHA 0.7

@interface ScannerController ()

@end

@implementation ScannerController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    //初始化扫描界面
    [self setScanView];
    _readerView = [[ ZBarReaderView alloc ] init ];
    //    _readerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _readerView . frame = CGRectMake ( 0 , 0 , VIEW_WIDTH , VIEW_HEIGHT);
    _readerView.tracksSymbols = NO;
    _readerView.allowsPinchZoom = YES;//使用手势变焦
    _readerView.readerDelegate = self;
    [ _readerView addSubview : _scanView ];
    //关闭闪光灯
    _readerView.torchMode = 0 ;
    [self.view addSubview : _readerView ];
    //扫描区域
    [ _readerView start ];
    [ self createTimer ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- ( void )setScanView
{
    //返回按钮
    UIButton *backButton = [[ UIButton alloc ] initWithFrame : CGRectMake ( 0 , 20 , 60.0 , 40.0 )];
    [backButton setTitle : @"返回" forState: UIControlStateNormal ];
    [backButton setTitleColor :[ UIColor whiteColor ] forState : UIControlStateNormal ];
    backButton. titleLabel . textAlignment = NSTextAlignmentLeft ;
    backButton. titleLabel . font =[ UIFont systemFontOfSize : 20.0 ];
    [backButton addTarget : self action : @selector (backToLoginForm) forControlEvents : UIControlEventTouchUpInside ];
    
    _scanView =[[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , VIEW_HEIGHT)];
    _scanView.backgroundColor =[ UIColor clearColor ];
    //最上部view
    UIView * upView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [upView addSubview :backButton];
    
    [ _scanView addSubview :upView];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA ;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView. layer . borderColor =[ UIColor whiteColor]. CGColor ;
    scanCropView. layer . borderWidth = 0.5 ;
    scanCropView. backgroundColor =[ UIColor clearColor ];
    [ _scanView addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[ UIView alloc ] initWithFrame : CGRectMake ( VIEW_WIDTH - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA ;
    rightView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :rightView];
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , VIEW_WIDTH , VIEW_HEIGHT -( VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop ))];
    downView. backgroundColor = [[ UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA ];
    [ _scanView addSubview :downView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , VIEW_WIDTH , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将二维码对准方框，即可自动扫描" ;
    [downView addSubview :labIntroudction];
    UIView *darkView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , downView. frame . size . height - 100.0 , VIEW_WIDTH , 100.0 )];
    darkView. backgroundColor = [[ UIColor blackColor ]  colorWithAlphaComponent : DARKCOLOR_ALPHA ];
    [downView addSubview :darkView];
    //用于开关灯操作的button
    openButton=[[ UIButton alloc ] initWithFrame : CGRectMake ( 10 , 20 , 300.0 , 40.0 )];
    [openButton setTitle : @"开启闪光灯" forState: UIControlStateNormal ];
    [openButton setTitleColor :[ UIColor whiteColor ] forState : UIControlStateNormal ];
    openButton. titleLabel . textAlignment = NSTextAlignmentCenter ;
    openButton. backgroundColor =[ UIColor grayColor ];
    openButton. titleLabel . font =[ UIFont systemFontOfSize : 22.0 ];
    openButton.layer.cornerRadius = 5;
    [openButton addTarget : self action : @selector (openLight) forControlEvents : UIControlEventTouchUpInside ];
    [darkView addSubview :openButton];
    //画中间的基准线
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , 2 )];
    _QrCodeline . backgroundColor = [ UIColor blackColor ];
    _QrCodeline.layer.borderWidth = 0.5 ;
    [ _scanView addSubview : _QrCodeline ];
}

-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols. zbarSymbolSet );
    NSString *symbolStr = [ NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    self.block(symbolStr);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- ( void )backToLoginForm
{
    [self dismissModalViewControllerAnimated:YES];
}

- ( void )openLight
{
    if ( _readerView . torchMode == 0 ) {
        _readerView . torchMode = 1 ;
        [openButton setTitle : @"关闭闪光灯" forState: UIControlStateNormal ];
    } else
    {
        _readerView . torchMode = 0 ;
        [openButton setTitle : @"开启闪光灯" forState: UIControlStateNormal ];
    }
}
- ( void )viewWillDisappear:( BOOL )animated
{
    [ super viewWillDisappear :animated];
    if ( _readerView . torchMode == 1 ) {
        _readerView . torchMode = 0 ;
    }
    [ self stopTimer ];
    [ _readerView stop ];
}

//二维码的横线移动
- ( void )moveUpAndDownLine
{
    CGFloat Y= _QrCodeline . frame . origin . y ;
    if (VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    }
}
- ( void )createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}
- ( void )stopTimer
{
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil ;
    }
}

@end
