//
//  QFLeftImageCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "QFLeftImageCell.h"

@implementation QFLeftImageCell

- (void)setLeftImage:(NSString *)image {
    _leftImage = image;
    self.imageView.image = [UIImage imageNamed:image];
}

- (void)setImageSize:(CGSize)size {
    _imageSize = size;
    UIGraphicsBeginImageContext(size);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)initUI {
    
    [self setImageSize:CGSizeMake(25, 25)];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

