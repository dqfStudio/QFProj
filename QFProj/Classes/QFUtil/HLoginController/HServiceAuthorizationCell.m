//
//  HServiceAuthorizationCell.m
//  QFProj
//
//  Created by dqf on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HServiceAuthorizationCell.h"

@interface HServiceAuthorizationCell ()
@property (nonatomic) NSMutableAttributedString *attributedString;
@property (nonatomic) HWebButtonView *buttonView;
@end

@implementation HServiceAuthorizationCell
- (NSMutableAttributedString *)attributedString {
    if (!_attributedString) {
        _buttonView = [[HWebButtonView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_buttonView setImage:[UIImage imageNamed:@"register_checkbox_icon"] forState:UIControlStateNormal];
        [_buttonView setImage:[UIImage imageNamed:@"register_checkbox_icon_h"] forState:UIControlStateSelected];
        [_buttonView setSelected:!_buttonView.isSelected];
        [_buttonView setPressed:^(HWebButtonView *buttonView, id data) {
            [buttonView setSelected:!buttonView.isSelected];
        }];
        
        _attributedString = [NSMutableAttributedString h_attachmentStringWithContent:_buttonView contentMode:UIViewContentModeScaleAspectFit attachmentSize:_buttonView.frame.size  alignToFont:[UIFont systemFontOfSize:14] alignment:HTextVerticalAlignmentCenter];
        
        NSString *string1 = @"点击开始，即表示已阅读并同意";
        NSString *string2 = @"《服务协议》";
        
        [_attributedString h_appendString:string1];
        [_attributedString h_appendString:string2];
        
        [_attributedString h_setColor:[UIColor colorWithString:@"#BABABF"] range:NSMakeRange(1, string1.length)];
        [_attributedString h_setColor:[UIColor colorWithString:@"#34BDD7"] range:NSMakeRange(string1.length+1, string2.length)];
        //设置点击
        HTextHighlight *highlight = HTextHighlight.new;
        @www
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @sss
                if (self.serviceAgreementBlock) {
                    self.serviceAgreementBlock();
                }
            });
        };
        [_attributedString h_setTextHighlight:highlight range:NSMakeRange(string1.length, string2.length)];
    }
    return _attributedString;
}
- (BOOL)isAuthorized {
    return _buttonView.isSelected;
}
- (void)initUI {
    self.label.attributedText = self.attributedString;
    [self.label setFont:[UIFont systemFontOfSize:12]];
    [self.label setTextAlignment:NSTextAlignmentCenter];
}
@end
