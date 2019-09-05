//
//  UIButton+HFilletLayer.m
//  QFProj
//
//  Created by wind on 2019/9/5.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "UIButton+HFilletLayer.h"

@implementation UIButton (HFilletLayer)
- (BOOL)fillet {
    return self.imageView.fillet;
}
- (void)setFillet:(BOOL)fillet {
    self.imageView.fillet = fillet;
}
- (UIImageViewFilletStyle)filletStyle {
    return self.imageView.filletStyle;
}
- (void)setFilletStyle:(UIImageViewFilletStyle)filletStyle {
    self.imageView.filletStyle = filletStyle;
}
@end
