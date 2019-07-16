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

typedef void(^HServiceAgreementBlock)(void);

@interface HServiceAuthorizationCell : HTupleLabelCell
@property(nonatomic, getter=isAuthorized) BOOL authorized; //default is YES
@property(nonatomic, copy) HServiceAgreementBlock serviceAgreementBlock;
@end
