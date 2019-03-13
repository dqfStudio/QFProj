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

#import "KTableView.h"
#import "HTableViewCell.h"
#import "HLeftImageCell.h"

#import "UIView+HShow.h"
#import "HFormController.h"
#import "NSObject+HAutoFill.h"
#import "NSObject+HUtil.h"
#import "NSDictionary+HSafeUtil.h"
#import "NSObject+selector.h"
#import "UIImage+Util.h"
#import "NSTimer+HUtil.h"
#import "HPrinterManager.h"
//#import "UIView+HPrinter.h"
#import "HSwitchLanguage.h"
#import "HPrinterHeader.h"
#import "UIImage+HName.h"
#import "HLoginController.h"
#import "HTableView.h"
#import "HTupleView.h"

@interface ViewController () <HTupleViewDelegate> {
    UILabel *label;
}
@property (nonatomic) NSString *TestString;
@property (nonatomic) BOOL yn;
@property (nonatomic) NSInteger ff;
@property (nonatomic) NSNumber *ww;
@property (nonatomic) NSInteger /*2-2*/count2;
@property (nonatomic) NSDate *date;
@property (nonatomic) KTableView *table;
@property (nonatomic) NSRange wcountRange;

H_CheckProperty(NSInteger, rrr)
@end

@implementation ViewController
H_CheckPropertyRange(rrr, 0, 150)

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"");
}
- (NSRange)wcountRange {
    return NSMakeRange(1, 2);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = UIImageView.new;
    UIImage *image = [UIImage imageNamed:@"qq"];
    NSLog(@"%@",image.accessibilityIdentifier);
    [imageView setImage:image];
    NSLog(@"%@",imageView.image.accessibilityIdentifier);
    
    UIView *view = UIView.new;
    [view setFrame:self.view.frame];
    [self.view addSubview:view];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"test" forKey:@"TestString"];
    [dict setObject:@"1" forKey:@"yn"];
    [dict setObject:@"22" forKey:@"ff"];
    [dict setObject:@"333" forKey:@"www"];
    [dict setObject:@"11111111" forKey:@"date"];
//    NSString *sf = dict[@"TestString"];
    
    [NSTimer scheduledTimerImmediatelyWithTimeInterval:2 times:2 block:^(NSTimer *timer) {
        NSLog(@"1111111111");
    } completion:^{
        NSLog(@"22222222222");
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:2 times:2 block:^(NSTimer *timer) {
        NSLog(@"1111111111");
    } completion:^{
        NSLog(@"22222222222");
    }];
    

    
    [self.navigationController pushViewController:HLoginController.new animated:YES];
    
    
//    [self performSelector:@selector(testAction) withObjects:nil];
//    NSLog(@"hello222");
//    NSString *ss = [NSString stringWithFormat:@"dqf_%@:",NSStringFromSelector(_cmd)];
    NSString *ss = @"dqf_viewDidLoad:ff:";
    
//    [self performSelector:NSSelectorFromString(ss) withObjects:@[@(3), @(4), @(5)]];
    
    NSInteger nu = 3;
    NSInteger rr = 5;
//    &nu;
    
//    [self performSelector:NSSelectorFromString(ss) withObjects:@[@(3)]];
    [self performSelector:NSSelectorFromString(ss) withMethodArgments:&nu, &rr];
    
//    [self performSelector:_cmd withPre:@"dqf" withMethodArgments:&nu, &rr];
    NSLog(@"hello");
}

- (void)dqf_viewDidLoad:(NSInteger)num ff:(NSInteger)rr {
    NSLog(@"world");
    [self performSelector:_cmd withPre:@"" withMethodArgments:&num, &rr];
}

- (NSInteger)_dqf_viewDidLoad:(NSInteger)num ff:(NSInteger)rr {
    NSLog(@"world");
    return 1;
//    [self performSelector:_cmd withPre:@"" withMethodArgments:&num, &rr];
}

- (void)dqf_viewDidLoad {
    NSLog(@"world");
}

- (void)testAction:(NSString *)pre {
    NSLog(@"world");
    
    NSString *selectorString = [NSString stringWithFormat:@"pre_%@:",NSStringFromSelector(_cmd)];
    SEL selector = NSSelectorFromString(selectorString);
    
    NSInteger nu = 3;
    NSInteger rr = 5;
    
    [self performSelector:selector withMethodArgments:&nu, &rr];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//
////    int a[10]={ 0,1,2,3,4,5,6,7,8,9 };
////    int arrA[3] = {2,3,4};
////    int arrB = *arrA;
////    int arrB = arrA[0];
////    int arrB = arrA;
////    arrA[0] = 5;
////    NSArray *arrA = @[@(1),@(2),@(3)];
////    NSArray *arrB = arrA;
////    arrA[0] = @(4);
////    char b='a'1;
//
////    NSInteger a=129,b=129;
//
//    NSLog(@"");
//
//    ViewController *vc = [ViewController autoFill];
//
//    [ViewController autoFillWithCount:2];
//
//    NSLog(@"%@",vc.TestString);
//    NSLog(@"%d",vc.yn);
//    NSLog(@"%ld",vc.ff);
//    NSLog(@"%@",vc.ww);
//    NSLog(@"%@",vc.date);
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"test" forKey:@"TestString"];
//    [dict setObject:@"1" forKey:@"yn"];
//    [dict setObject:@"22" forKey:@"ff"];
//    [dict setObject:@"333" forKey:@"www"];
//    [dict setObject:@"11111111" forKey:@"date"];
//    NSString *sf = dict[@"TestString"];
//
////    NSString *sf2 = dict[0];
//
//    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
//    [dict2 setObject:@"www" forKey:@"ww"];
//    [self autoFill:dict map:dict2];
//
//    NSLog(@"%@",self.TestString);
//    NSLog(@"%d",self.yn);
//    NSLog(@"%ld",self.ff);
//    NSLog(@"%@",self.ww);
//    NSLog(@"%@",self.date);
//    //icon_tuple_arrow_down@2x
////    UIImage *imageA = [UIImage imageNamed:@"icon_tuple_arrow_up"];
////    UIImage *imageB = [UIImage imageNamed:@"icon_tuple_arrow_down"];
////    Similarity value = [HSimilarity getSimilarityWithImage:imageA image:imageB];
//    NSLog(@"");
//
////    UITableViewCell *btn;
//
//    UIView *bgView = [[UIView alloc] init];
////    [self.view addSubview:bgView];
//
//    label = [[UILabel alloc] init];
////    [label setFrame:CGRectMake(100, 100, 150, 100)];
//    [label setBackgroundColor:[UIColor redColor]];
////    [label setFrame:CGRectMake(100, 100, 10, 10)];
//
////    [label setSelected:YES];
////    [label setText:@"hello福建省拉法基啊放假啊类似飞机案例；放假啊类似飞机啊；了房间啊；房价啊；放假啊；房价啊；峰" forState:UILabelStateNormal];
//    [label setText:@"hello" forState:UILabelStateNormal];;
//    CGRect frame22 = CGRectMake(100, 100, 100, 100);
////    CGSize size = label.intrinsicContentSize;
////    frame22.size.width = 100;
////    frame22.size.height = size.height*size.width/100;
//    [label setFrame:frame22];
//    [label setNumberOfLines:0];
//    [label setText:@"world" forState:UILabelStateSelected];
////    size = bgView.intrinsicContentSize;
//    [bgView addSubview:label];
////    size = bgView.intrinsicContentSize;
//    @weakify(label)
//    [label addSingleTapGestureWithBlock:^(UITapGestureRecognizer *recognizer) {
//        @strongify(label)
//        if (label.isSelected) {
//            [label setSelected:YES];
//        }else {
//            [label setSelected:NO];
//        }
//    }];
//    UIImageView *view = [UIImageView new];
//    if ([view isKindOfClass:UIView.class]) {
//        NSLog(@"");
//    }else {
//        NSLog(@"");
//    }
////
//    [label setTextColor:[UIColor redColor] forState:UILabelStateNormal];
//    [label setTextColor:[UIColor greenColor] forState:UILabelStateSelected];
//////    [label setSelected:YES];
//    [label setFont:[UIFont systemFontOfSize:15] forState:UILabelStateNormal];
//    [label setFont:[UIFont systemFontOfSize:35] forState:UILabelStateSelected];
////
//    [label setBackgroundColor:[UIColor redColor] forState:UILabelStateNormal];
//    [label setBackgroundColor:[UIColor yellowColor] forState:UILabelStateSelected];
////    [label setSelected:YES];
//
//    UIView *accView = [UIView new];
//    [accView setBackgroundColor:[UIColor blackColor]];
//
//    UIView *accView2 = [UIView new];
//    [accView2 setBackgroundColor:[UIColor blackColor]];
//
//    UIView *accView3 = [UIView new];
//    [accView3 setBackgroundColor:[UIColor yellowColor]];
//
//    UIView *accView4 = [UIView new];
//    [accView4 setBackgroundColor:[UIColor blueColor]];
//
////    UIEdgeInsetsMake(0, 0, 0, 0);
////    [label setAccessoryView:accView edgeInsets:HEdgeInsetsMake(10, 10, 10)];
////    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//不可以被压缩，尽量显示完整
//
//    [self.view addSubview:label];
//
//    HLabelView *labelView = [[HLabelView alloc]initWithFrame:CGRectMake(100, 100, 150, 100)];
////    [labelView setFrame:CGRectMake(100, 100, 150, 100)];
//    [labelView setBackgroundColor:[UIColor redColor]];
//    [labelView.label setText:@"事发后撒发货哦啊放假啊房价法搜撒娇哦"];
////    [labelView.label setText:@"事发"];
//    [labelView.label setNumberOfLines:0];
//    [label setBackgroundColor:[UIColor blueColor]];
//    [labelView setLeftView:accView];
//    [labelView setRightView:accView2];
//    [labelView setLeftEdgeInsets:HEdgeInsetsMake(20, 80, 0, 10)];
//    [labelView setRightEdgeInsets:HEdgeInsetsMake(20, 80, 10, 0)];
//    [labelView setTopView:accView3];
//    [labelView setBottomView:accView4];
//    [labelView setTopEdgeInsets:HSideEdgeInsetsMake(20, 6, 3)];
//    [labelView setBottomEdgeInsets:HSideEdgeInsetsMake(20, 6, 3)];
////    [self.view addSubview:labelView];
//
//    UIButton *btn = [[UIButton alloc] init];
//    [btn setFrame:CGRectMake(100, 300, 80, 80)];
//    [btn setBackgroundColor:[UIColor redColor]];
//    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:btn];
//
////    [self.navigationController pushViewController:[TestViewController new] animated:YES];
//
////    NSLog(@"%@",[NSFileManager documentPath:nil]);
//
//    CGRect frame = self.view.frame;
//    frame.origin.y = 64;
////    frame.size.height = 90*2;
////    HTupleView *tupleView = [[HTupleView alloc] initWithFrame:frame scrollDirection:HTupleViewScrollDirectionHorizontal];
////    [tupleView setTupleDelegate:self];
////    [tupleView setBackgroundColor:[UIColor whiteColor]];
//////    [self.view addSubview:tupleView];
////    [self.view setBackgroundColor:[UIColor orangeColor]];
//
//
//
//
//
//    _table = [[HTableView alloc] initWithFrame:frame];
//    [_table setBackgroundColor:[UIColor clearColor]];
////    [self.view addSubview:_table];
//
//    @www
//    self.table.refreshBlock = ^{
//        @sss
////        NSArray *arr = @[@"sectionModel<0>cellModel",
////                         @"sectionModel<0>cellModel",
////                         @"sectionModel<0>cellModel",
////                         @"sectionModel<1>cellModel2"];
//        NSArray *arr = @[@"sectionModel<0>cellModel",
//                         @"sectionModel<0>cellModel",
//                         @"sectionModel<0>cellModel"];
//        sleep(2);
//        [self.table refreshView:self withArr:arr];
//    };
//
//    //先刷新一次数据
//    [self.table beginRefresh];
//
//
//    [self.view showWaiting:^(id<HWaitingProtocol> make) {
//        [make setGrayStyle];
//    }];
//
//    [self.view showLoadError:^(id<HLoadErrorProtocol> make) {
//        [make setDisplayImage:NO];
//    }];
//
////    [self.view showAlert:^(id<HAlertProtocol> make) {
////        [make setTitle:@"消息"];
////        [make setCancelTitle:@"quxiao"];
////        [make setButtonTitles:@[@"1", @"2"]];
////        [make setCompletionBlock:^(NSInteger buttonIndex) {
////            NSLog(@"");
////        }];
////    }];
//
////    [self.view showSheet:^(id<HSheetProtocol> make) {
////        [make setTitle:@"消息"];
////        [make setCancelTitle:@"quxiao"];
////        [make setButtonTitles:@[@"1", @"2"]];
////        [make setCompletionBlock:^(NSInteger buttonIndex) {
////            NSLog(@"");
////        }];
////
////    }];
//
////    [self.view showNaviToast:^(id<HNaviToastProtocol> make) {
////        [make setDesc:@"消息来了"];
////    }];
//
////    [self.view showToast:^(id<HToastProtocol> make) {
////        [make setDesc:@"消息来了"];
////    }];
//
////    [self.view showForm:^(id<HFormProtocol> make) {
//////        - (void)setScrollDirection:(NSInteger)direction; //0垂直滚动， 1水平滚动，默认为0
//////        - (void)setItems:(NSInteger)items;
//////        - (void)setLineItem:(NSInteger)items;
//////        - (void)setEdgeInsets:(UIEdgeInsets)edgeInsets;
//////        - (void)setButtonBlock:(void (^)(NSInteger buttonIdex))block;
//////        - (void)setPages:(NSInteger)page; //只针对横向布局有用
//////        - (void)setBackgroundColor:(UIColor *)color;
//////        - (void)setItemBackgroundColor:(UIColor *)color;
//////        [make setScrollDirection:1];
//////        [make setPages:2];
////        [make setTitles:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"] icon:nil];
////        [make setPageLines:2];
////        [make setItemBackgroundColor:[UIColor redColor]];
////
////        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
////        [view1 setBackgroundColor:[UIColor yellowColor]];
////        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
////        [view2 setBackgroundColor:[UIColor blueColor]];
////
////        [make setHeaderView:view1];
////        [make setFooterView:view2];
////    }];
//
////    [HFormController formControllerWithTitles:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"] icons:nil lineItems:5 pageLines:2 edgeInsets:UIEdgeInsetsZero buttonBlock:^(NSInteger index) {
////        NSLog(@"");
////    } bgColor:[UIColor redColor] itemBgColor:[UIColor redColor]];
//
//    [self.view showForm:^(id<HFormProtocol> make) {
//        [make setTitles:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"] icon:nil];
////        [make setLineItems:5];
////        [make setPageLines:2];
////        [make setBackgroundColor:[UIColor redColor]];
////        [make setItemBackgroundColor:[UIColor redColor]];
//    }];
//
//}

- (void)sectionModel:(HSM)model {
    model.headerHeight = 22;
}

- (void)cellModel:(id)sender {
    HCellModel *cellModel = sender;
    cellModel.height = 80;
    cellModel.renderBlock = [self renderBlock];
    cellModel.selectionBlock = [self selectionBlock];
}

- (void)cellModel2:(HCM)model {
    model.height = 55;
    model.renderBlock = [self renderBlock2];
    model.selectionBlock = [self selectionBlock];
//    [model cellBlock:^UITableViewCell *(NSIndexPath *indexPath, HTableView *table) {
//
//        return nil;
//    } selectionBlock:^(NSIndexPath *indexPath, HTableView *table) {
//
//    }];
}

- (HCellRenderBlock)renderBlock {
    return ^UITableViewCell *(NSIndexPath *indexPath, KTableView *table) {
        
        HLeftImageCell *cell = [table registerCell:HLeftImageCell.class indexPath:indexPath];
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
    return ^UITableViewCell *(NSIndexPath *indexPath, KTableView *table) {
        
        HTableViewCell *cell = [table registerCell:HTableViewCell.class indexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.35]];
        cell.textLabel.text = @"路径追踪2";
        //        cell.callback = ^(UISwitch *sender) {};
        return cell;
    };
}

- (HCellSelectionBlock)selectionBlock {
    return ^(NSIndexPath *indexPath, KTableView *table) {
        [table deselectRowAtIndexPath:indexPath animated:YES];
    };
}

- (NSInteger)numberOfSectionsInTupleView:(UICollectionView *)tupleView {
    return 2;
}
- (NSInteger)tupleView:(UICollectionView *)tupleView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)tupleView:(UICollectionView *)tupleView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(190, 30);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(100, 90);
}
- (CGSize)tupleView:(UICollectionView *)tupleView sizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(30, 90);
}
//- (UIEdgeInsets)tupleView:(UICollectionView *)tupleView edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return UIEdgeInsetsMake(10, 0, 10, 0);
//}
- (void)tupleView:(UICollectionView *)tupleView itemTuple:(id (^)(id iblk, Class cls, id pre, bool idx))itemBlock atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HLabelViewCell *cell = itemBlock(nil, HLabelViewCell.class, nil, YES);
            [cell.label setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
//            [cell setInitBlock:^{
//
//            }];
            [cell setSignalBlock:^(HTupleSignal *signal) {
                
            }];
        }
            break;
        case 1:
        {
            HTupleVerticalCell *cell = itemBlock(nil, HTupleVerticalCell.class, nil, YES);
//            [cell.button setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor redColor]];
        }
            break;
        case 2:
        {
            HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                HTupleSignal *signal = [HTupleSignal new];
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                signal.signal = @"hello";
                [tupleView signal:signal indexPath:tmpIndexPath];
            }];
        }
            break;
        case 3:
        {
            HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setImageViewBlock:^(HWebImageView *webImageView, HImageViewCell *imageCell) {
                
            }];
        }
            break;
            
        default:
        {
            HImageViewCell *cell = itemBlock(nil, HImageViewCell.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

- (void)tupleView:(UICollectionView *)tupleView headerTuple:(id (^)(id iblk, Class cls, id pre, bool idx))headerBlock inSection:(NSInteger)section {
    switch (section) {
        case 0:{
            HReusableLabelView *cell = headerBlock(nil, HReusableLabelView.class, nil, YES);
            [cell.label setBackgroundColor:[UIColor yellowColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 1:
        {
            HReusableButtonView *cell = headerBlock(nil, HReusableButtonView.class, nil, YES);
            [cell.buttonView setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 2:
        {
            HReusableImageView *cell = headerBlock(nil, HReusableImageView.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
            
        default:
        {
            HReusableImageView *cell = headerBlock(nil, HReusableImageView.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

- (void)tupleView:(UICollectionView *)tupleView footerTuple:(id (^)(id iblk, Class cls, id pre, bool idx))footerBlock inSection:(NSInteger)section {
    switch (section) {
        case 0:{
            HReusableLabelView *cell = footerBlock(nil, HReusableLabelView.class, nil, YES);
            [cell.label setBackgroundColor:[UIColor yellowColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 1:
        {
            HReusableButtonView *cell = footerBlock(nil, HReusableButtonView.class, nil, YES);
            [cell.buttonView setBackgroundColor:[UIColor blueColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case 2:
        {
            HReusableImageView *cell = footerBlock(nil, HReusableImageView.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
            
        default:
        {
            HReusableImageView *cell = footerBlock(nil, HReusableImageView.class, nil, YES);
            [cell.imageView setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
            break;
    }
}

//- (void)tupleView:(UICollectionView *)tupleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)btnAction {
    NSLog(@"%@",label);
    if (label.isSelected) {
        [label setSelected:NO];
    }else {
        [label setSelected:YES];
    }
}

@end
