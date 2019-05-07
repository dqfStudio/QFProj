//
//  HTableHeaderFooterView.h
//  QFProj
//
//  Created by wind on 2019/4/12.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HBaseHeaderFooterView.h"
#import "HTupleView.h"
#import "HLabel.h"

@interface HTableHeaderFooterView : HBaseHeaderFooterView

@end

@interface HTableLabelView : HBaseHeaderFooterView
@property (nonatomic) HLabel *label;
@end

@interface HTableVerticalView : HBaseHeaderFooterView
@property (nonatomic) HTupleView *tuple;
@end

@interface HTableHorizontalView : HBaseHeaderFooterView
@property (nonatomic) HTupleView *tuple;
@end
