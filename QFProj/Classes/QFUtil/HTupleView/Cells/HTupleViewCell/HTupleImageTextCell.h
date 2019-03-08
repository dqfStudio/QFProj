//
//  HTupleImageTextCell.h
//  QFProj
//
//  Created by wind on 2019/3/8.
//  Copyright © 2019年 dqfStudio. All rights reserved.
//

#import "HTupleView.h"

typedef void(^HTupleImageTextBlock)(NSInteger idx);

@interface HTupleImageTextModel : NSObject
@property (nonatomic, copy) NSString *cellImage;
@property (nonatomic, copy) NSString *cellText;
@end

@interface HTupleImageTextCell : HTupleBaseCell <HTupleViewDelegate>
@property (nonatomic) HTupleView *tupleView;
@property (nonatomic) HTupleImageTextModel *model;
@property (nonatomic) NSInteger textHeight;//default 25
@property (nonatomic, copy) HTupleImageTextBlock imageTextBlock;
@end
