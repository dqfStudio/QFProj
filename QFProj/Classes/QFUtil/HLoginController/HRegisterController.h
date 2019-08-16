//
//  HRegisterController.h
//  QFProj
//
//  Created by wind on 2019/7/15.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HViewController.h"
#import "HTupleView.h"

@interface HRegisterController : HViewController
@property (nonatomic) HTupleView *tupleView;
- (void)tuple_tupleView:(HTupleView *)tupleView itemTuple:(HTupleItem)itemBlock atIndexPath:(NSIndexPath *)indexPath;
@end
