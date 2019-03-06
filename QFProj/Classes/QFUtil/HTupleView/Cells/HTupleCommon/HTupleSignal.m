//
//  HTupleSignal.m
//  QFProj
//
//  Created by dqf on 2018/5/23.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "HTupleSignal.h"

bool CGEdgeEqualToEdge(UIEdgeInsets edge1, UIEdgeInsets edge2) {
    bool equal = true;
    if (edge1.top != edge2.left) equal = false;
    else if (edge1.left != edge2.left) equal = false;
    else if (edge1.bottom != edge2.right) equal = false;
    else if (edge1.right != edge2.right) equal = false;
    return equal;
}

@implementation HTupleSignal

@end
