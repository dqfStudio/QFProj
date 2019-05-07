//
//  HTableViewCell.m
//  MGMobileMusic
//
//  Created by dqf on 2017/8/4.
//  Copyright © 2017年 migu. All rights reserved.
//

#import "HTableViewCell.h"

@implementation HTableViewCell
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)layoutContentView {
    //HLayoutTableView(self.tuple)
}
@end

@implementation HTableViewCellValue1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)layoutContentView {
    //HLayoutTableView(self.tuple)
}
@end

@implementation HTableViewCellValue2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)layoutContentView {
    //HLayoutTableView(self.tuple)
}
@end

@implementation HTableViewCellSubtitle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)layoutContentView {
    //HLayoutTableView(self.tuple)
}
@end

