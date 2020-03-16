//
//  HGameVC.h
//  QFProj
//
//  Created by dqf on 2018/9/30.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "WKWebViewJavascriptBridge.h"

@interface HWebviewVC : HViewController
@property (nonatomic, copy) NSString *gameType;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic) BOOL hideNaviBar;//default is NO.
@property (nonatomic) BOOL displayProgress;//default is NO.
@property (nonatomic) BOOL autorotate;//default is NO.
@end
