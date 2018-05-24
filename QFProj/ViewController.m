//
//  ViewController.m
//  QFProj
//
//  Created by dqf on 2018/4/27.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+HAutoFill.h"
#import "NSObject+HAspects.h"
#import "TestViewController.h"
#import "QFButton.h"
#import "NSFileManager+HUtil.h"
#import "UILabel+HState.h"
#import "HLabelView.h"
#import "HTupleView.h"
#import "HTupleVerticalCell.h"
#import "HSimilarity.h"

#import "HTableView.h"
#import "HLeftImageCell.h"
#import "HLeftImageCell2.h"

@interface ViewController () <HTupleViewDelegate> {
    UILabel *label;
}
@property (nonatomic) NSString *TestString;
@property (nonatomic) BOOL yn;
@property (nonatomic) NSInteger ff;
@property (nonatomic) NSNumber *ww;
@property (nonatomic) NSDate *date;
@property (nonatomic) HTableView *table;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"test" forKey:@"TestString"];
    [dict setObject:@"1" forKey:@"yn"];
    [dict setObject:@"22" forKey:@"ff"];
    [dict setObject:@"333" forKey:@"www"];
    [dict setObject:@"11111111" forKey:@"date"];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setObject:@"www" forKey:@"ww"];
    [self autoFillWithParams:dict map:dict2];
    
    NSLog(@"%@",self.TestString);
    NSLog(@"%d",self.yn);
    NSLog(@"%ld",self.ff);
    NSLog(@"%@",self.ww);
    NSLog(@"%@",self.date);
    //icon_tuple_arrow_down@2x
//    UIImage *imageA = [UIImage imageNamed:@"icon_tuple_arrow_up"];
//    UIImage *imageB = [UIImage imageNamed:@"icon_tuple_arrow_down"];
//    Similarity value = [HSimilarity getSimilarityWithImage:imageA image:imageB];
    NSLog(@"");
    
//    UITableViewCell *btn;
    
    label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(100, 100, 150, 100)];
//    [label setSelected:YES];
    [label setText:@"hello福建省拉法基啊放假啊类似飞机案例；放假啊类似飞机啊；了房间啊；房价啊；放假啊；房价啊；峰" forState:UILabelStateNormal];
    [label setNumberOfLines:0];
    [label setText:@"world" forState:UILabelStateSelected];
    
    [label setTextColor:[UIColor blueColor] forState:UILabelStateNormal];
    [label setTextColor:[UIColor greenColor] forState:UILabelStateSelected];
//    [label setSelected:YES];
    [label setFont:[UIFont systemFontOfSize:15] forState:UILabelStateNormal];
    [label setFont:[UIFont systemFontOfSize:35] forState:UILabelStateSelected];
    
    [label setBackgroundColor:[UIColor redColor] forState:UILabelStateNormal];
    [label setBackgroundColor:[UIColor yellowColor] forState:UILabelStateSelected];
//    [label setSelected:YES];

    UIView *accView = [UIView new];
    [accView setBackgroundColor:[UIColor blackColor]];
    
    UIView *accView2 = [UIView new];
    [accView2 setBackgroundColor:[UIColor blackColor]];
    
    UIView *accView3 = [UIView new];
    [accView3 setBackgroundColor:[UIColor yellowColor]];
    
    UIView *accView4 = [UIView new];
    [accView4 setBackgroundColor:[UIColor blueColor]];
    
//    UIEdgeInsetsMake(0, 0, 0, 0);
//    [label setAccessoryView:accView edgeInsets:HEdgeInsetsMake(10, 10, 10)];
    
    
//    [self.view addSubview:label];
    
    HLabelView *labelView = [[HLabelView alloc]initWithFrame:CGRectMake(100, 100, 150, 100)];
//    [labelView setFrame:CGRectMake(100, 100, 150, 100)];
    [labelView setBackgroundColor:[UIColor redColor]];
    [labelView.label setText:@"事发后撒发货哦啊放假啊房价法搜撒娇哦"];
//    [labelView.label setText:@"事发"];
    [labelView.label setNumberOfLines:0];
    [label setBackgroundColor:[UIColor blueColor]];
    [labelView setLeftView:accView];
    [labelView setRightView:accView2];
    [labelView setLeftEdgeInsets:HEdgeInsetsMake(20, 80, 0, 10)];
    [labelView setRightEdgeInsets:HEdgeInsetsMake(20, 80, 10, 0)];
    [labelView setTopView:accView3];
    [labelView setBottomView:accView4];
    [labelView setTopEdgeInsets:HSideEdgeInsetsMake(20, 6, 3)];
    [labelView setBottomEdgeInsets:HSideEdgeInsetsMake(20, 6, 3)];
//    [self.view addSubview:labelView];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake(100, 300, 80, 80)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
    
//    NSLog(@"%@",[NSFileManager documentPath:nil]);
    
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
//    frame.size.height = 90*2;
//    HTupleView *tupleView = [[HTupleView alloc] initWithFrame:frame scrollDirection:HTupleViewScrollDirectionHorizontal];
//    [tupleView setTupleDelegate:self];
//    [tupleView setBackgroundColor:[UIColor whiteColor]];
////    [self.view addSubview:tupleView];
//    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    
    _table = [[HTableView alloc] initWithFrame:frame];
    [_table setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_table];
    
    @www
    self.table.refreshBlock = ^{
        @sss
//        NSArray *arr = @[@"sectionModel<0>cellModel",
//                         @"sectionModel<0>cellModel",
//                         @"sectionModel<0>cellModel",
//                         @"sectionModel<1>cellModel2"];
        NSArray *arr = @[@"sectionModel<0>cellModel",
                         @"sectionModel<0>cellModel",
                         @"sectionModel<0>cellModel"];
        sleep(2);
        [self.table refreshView:self withArr:arr];
    };
    
    //先刷新一次数据
    [self.table beginRefresh];
    
}

- (void)sectionModel:(id)sender {
    HSectionModel *sectionModel = sender;
    sectionModel.headerHeight = 22;
}

- (void)cellModel:(id)sender {
    HCellModel *cellModel = sender;
    cellModel.height = 80;
    cellModel.renderBlock = [self renderBlock];
    cellModel.selectionBlock = [self selectionBlock];
}

- (void)cellModel2:(id)sender {
    HCellModel *cellModel = sender;
    cellModel.height = 55;
    cellModel.renderBlock = [self renderBlock2];
    cellModel.selectionBlock = [self selectionBlock];
}

- (HCellRenderBlock)renderBlock {
    return ^UITableViewCell *(NSIndexPath *indexPath, HTableView *table) {
        
        HLeftImageCell2 *cell = [table registerCell:HLeftImageCell2.class indexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"路径追踪";
////                cell.callback = ^(UISwitch *sender) {};
//                break;
//            case 1:
//                cell.textLabel.text = @"网络调试";
////                cell.callback = ^(UISwitch *sender) {};
//                break;
//            case 2:
//                cell.textLabel.text = @"点击追踪";
////                cell.callback = ^(UISwitch *sender) {};
//                break;
//
//            default:
//                cell.textLabel.text = @"else";
//                break;
//        }
        return cell;
    };
}

- (HCellRenderBlock)renderBlock2 {
    return ^UITableViewCell *(NSIndexPath *indexPath, HTableView *table) {
        
        HLeftImageCell *cell = [table registerCell:HLeftImageCell.class indexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
        cell.textLabel.text = @"路径追踪2";
        //        cell.callback = ^(UISwitch *sender) {};
        return cell;
    };
}

- (HCellSelectionBlock)selectionBlock {
    return ^(NSIndexPath *indexPath, HTableView *table) {
        [table deselectRowAtIndexPath:indexPath animated:YES];
    };
}

- (NSInteger)numberOfSectionsInTupleView:(UIView *)tupleView {
    return 2;
}
- (NSInteger)tupleView:(UIView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)tupleView:(UIView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(190, 30);
}
- (CGSize)tupleView:(UIView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(100, 90);
}
- (CGSize)tupleView:(UIView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(30, 90);
}
//- (UIEdgeInsets)tupleView:(UIView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return UIEdgeInsetsMake(10, 0, 10, 0);
//}
- (void)tupleView:(UIView *)tupleView itemTuple:(id (^)(Class aClass))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HTextViewCell *cell = itemBlock(HTextViewCell.class);
            [cell.label setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setInitBlock:^{
                
            }];
        }
            break;
        case 1:
        {
            HTupleVerticalCell *cell = itemBlock(HTupleVerticalCell.class);
//            [cell.button setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor redColor]];
        }
            break;
        case 2:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView) {
                
            }];
        }
            break;
        case 3:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView) {
                
            }];
        }
            break;
            
        default:
        {
            HImageViewCell *cell = itemBlock(HImageViewCell.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

- (void)tupleView:(UIView *)tupleView headerTuple:(id (^)(Class aClass))headerBlock inSection:(NSInteger)section {
    switch (section) {
        case 0:{
            HReusableTextView *cell = headerBlock(HReusableTextView.class);
            [cell.label setBackgroundColor:[UIColor yellowColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 1:
        {
            HReusableButtonView *cell = headerBlock(HReusableButtonView.class);
            [cell.button setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 2:
        {
            HReusableImageView *cell = headerBlock(HReusableImageView.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
            
        default:
        {
            HReusableImageView *cell = headerBlock(HReusableImageView.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

- (void)tupleView:(UIView *)tupleView footerTuple:(id (^)(Class aClass))footerBlock inSection:(NSInteger)section {
    switch (section) {
        case 0:{
            HReusableTextView *cell = footerBlock(HReusableTextView.class);
            [cell.label setBackgroundColor:[UIColor yellowColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 1:
        {
            HReusableButtonView *cell = footerBlock(HReusableButtonView.class);
            [cell.button setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 2:
        {
            HReusableImageView *cell = footerBlock(HReusableImageView.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
            
        default:
        {
            HReusableImageView *cell = footerBlock(HReusableImageView.class);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

//- (void)tupleView:(UIView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)btnAction {
    NSLog(@"%@",label);
    if (label.isSelected) {
        [label setSelected:NO];
    }else {
        [label setSelected:YES];
    }
}

@end
