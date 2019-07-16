//
//  HServiceAuthorizationCell.h
//  QFProj
//
//  Created by wind on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HTupleViewCell.h"
#import "UIColor+HUtil.h"
#import "NSAttributedString+HText.h"

typedef void(^HAuthorizeBlock)(void);

@interface HServiceAuthorizationCell : HTupleLabelCell
@property(nonatomic, getter=isAuthorized) BOOL authorized; //default is YES
@property(nonatomic, copy) HAuthorizeBlock authorizeBlock;
@end
