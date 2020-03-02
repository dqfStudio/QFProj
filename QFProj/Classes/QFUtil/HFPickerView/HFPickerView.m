//
//  HFPickerView.m
//  QFProj
//
//  Created by dqf on 2019/3/23.
//  Copyright © 2019年 dqf. All rights reserved.
//

#import "HFPickerView.h"

#define KHRect(x, y, w, h)  CGRectMake([UIScreen mainScreen].bounds.size.width *x, [UIScreen mainScreen].bounds.size.height *y, [UIScreen mainScreen].bounds.size.width *w,  [UIScreen mainScreen].bounds.size.height *h)
#define KHFont(f) [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width *f]
#define KHColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define KHMainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
#define KHBlueColor [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]
#define KHClearColor [UIColor clearColor]

@interface HFPickerView () <UITableViewDelegate, UITableViewDataSource>
/** view */
@property (nonatomic, strong) UIView *topView;
/** button */
@property (nonatomic, strong) UIButton *doneBtn;
/** pickerView */
//@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UITableView *tableView;
/** srting */
@property (nonatomic, strong) NSMutableArray *resultArr;

@end

@implementation HFPickerView

- (NSMutableArray *)resultArr {
    if (!_resultArr) {
        _resultArr = NSMutableArray.array;
    }
    return _resultArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:KHRect(0, 0, 1, 917/667)];
    if (self) {
        self.backgroundColor = KHColorAlpha(0, 0, 0, 0.4);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topView = [[UIView alloc]initWithFrame:KHRect(0, 667/667, 1, 250/667)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    //为view上面的两个角做成圆角。不喜欢的可以注掉
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.doneBtn setFrame:KHRect(320/375, 5/667, 50/375, 40/667)];
    [self.doneBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.doneBtn];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:KHRect(100/375, 0, 175/375, 50/667)];
    titlelb.backgroundColor = KHClearColor;
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.text = self.title;
    titlelb.font = KHFont(20/375);
    [self.topView addSubview:titlelb];
    
    self.tableView = [[UITableView alloc]init];
    [self.tableView setFrame:KHRect(0, 50/667, 1, 200/667)];
    [self.tableView setBackgroundColor:KHMainBackColor];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.topView addSubview:self.tableView];
    if (self.selectedArray.count > 0) {
        [self.resultArr addObjectsFromArray:self.selectedArray];
    }
}

//快速创建
+ (instancetype)pickerView {
    return [[self alloc]init];
}

//弹出
- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    // 浮现
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = self.center;
        point.y -= 250;
        self.center = point;
    } completion:^(BOOL finished) {
        
    }];
    [view addSubview:self];
}

- (void)quit {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        CGPoint point = self.center;
        point.y += 250;
        self.center = point;
    } completion:^(BOOL finished) {
        if (self.selectionBlock) {
            NSString *tmpStr = @"";
            for (NSString *str in self.resultArr) {
                tmpStr = [tmpStr stringByAppendingFormat:@",%@",str];
            }
            if (tmpStr.length > 0 && [[tmpStr substringToIndex:1] isEqualToString:@","]) {
                tmpStr = [tmpStr substringFromIndex:1];
            }
            self.selectionBlock(tmpStr);
        }
        [self removeFromSuperview];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellTableIndentifier = @"cellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTableIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTableIndentifier];
    }
    NSString *content = self.array[indexPath.row];
    if ([self.resultArr containsObject:content]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [cell.textLabel setText:content];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:cell.selected animated:YES];
    NSString *content = self.array[indexPath.row];
    if (content && [self.resultArr containsObject:content]) {
        [self.resultArr removeObject:content];
    }else if (content) {
        [self.resultArr addObject:content];
    }
    [tableView reloadData];
}

@end
