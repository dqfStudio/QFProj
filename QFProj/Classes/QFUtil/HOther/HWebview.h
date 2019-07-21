//
//  HWebview.h
//  QFProj
//
//  Created by wind on 2019/7/21.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface HWebview : WKWebView

@property (nonatomic) WKWebViewJavascriptBridge *bridge;
@property (nonatomic) BOOL autorotate;//default is NO.
@property (nonatomic) UIEdgeInsets rotateEdgeInsets;
@property (nonatomic) BOOL displayProgress;//default is NO.

- (nullable WKNavigation *)loadURL:(NSURL *)url;
- (nullable WKNavigation *)loadURLString:(NSString *)urlString;
- (nullable WKNavigation *)loadHTMLFile:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
