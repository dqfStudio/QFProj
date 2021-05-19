//
//  HLocationPicker.m
//  QFProj
//
//  Created by dqf on 2020/2/22.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HLocationPicker.h"
#import "HToolBar.h"

static CGFloat const PickerViewHeight1 = 240;

@interface HLocationPicker () <UIPickerViewDataSource, UIPickerViewDelegate> {
    CGFloat PickerViewHeight;
}
//data
@property (nonatomic, strong) NSDictionary *pickerDict;
@property (nonatomic, strong) NSArray  *pickerArray;
/** 当前省数组 */
@property (nonatomic, strong) NSArray *provinceArray;
/** 当前城市数组 */
@property (nonatomic, strong) NSArray *cityArray;
/** 当前地区数组 */
@property (nonatomic, strong) NSArray *townArray;
/** 当前选中数组 */
@property (nonatomic, strong) NSArray *selectedArray;

/** 选择器 */
@property (nonatomic, strong, nullable) UIPickerView *pickerView;
/** 工具器 */
@property (nonatomic, strong, nullable) HToolBar *toolBar;
/** 边线 */
@property (nonatomic, strong, nullable) UIView *lineView;

@end

@implementation HLocationPicker

- (instancetype)initWithSlectedLocation:(HSelectedLocation)selectedLocation {
    self = [self init];
    self.selectedLocation = selectedLocation;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        PickerViewHeight = PickerViewHeight1 + UIScreen.bottomBarHeight;
        [self setupUI];
        [self loadData];
    }
    return self;
}

- (void)setupUI {
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    [self.layer setOpaque:0.0];
    [self addSubview:self.pickerView];
    [self.pickerView addSubview:self.lineView];
    [self addSubview:self.toolbar];
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
}

- (NSArray *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)loadData {
    self.pickerArray = [[NSArray alloc] initWithArray:[self readLocalFileWithName:@"province"]];
    self.provinceArray = [[NSArray alloc] initWithArray:self.pickerArray];
    self.cityArray = [[NSArray alloc] initWithArray:self.provinceArray[0][@"city"]];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    }else {
        return self.cityArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[self.provinceArray objectAtIndex:row]objectForKey:@"name"];
    }else {
        return [[self.cityArray objectAtIndex:row]objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.cityArray = [[NSArray alloc] initWithArray:self.provinceArray[row][@"city"]];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }
//    [pickerView selectedRowInComponent:1];
    
//    [pickerView selectedRowInComponent:2];
    
//    if (component == 1) {
//        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
//            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
//        } else {
//            self.townArray = nil;
//        }
//        [pickerView selectRow:1 inComponent:2 animated:YES];
//    }
//    
//    [pickerView reloadComponent:2];

}

//自定义pcierview显示
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    NSString *text;
    if (component == 0) {
        text =  [[self.provinceArray objectAtIndex:row]objectForKey:@"name"];
    }else if (component == 1){
        text =  [[self.cityArray objectAtIndex:row]objectForKey:@"name"];
    }
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}

- (BOOL)isRolling:(UIView *)view {
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) return YES;// 如果UIPickerView正在拖拽或者是正在减速，返回YES
    }
    
    for (UIView *subView in view.subviews) {
        if ([self isRolling:subView]) {
            return YES;
        }
    }
    return NO;
}

- (void)cancelAction {
    [self remove];
}

- (void)confirmAction {
    if([self isRolling:self.pickerView]) return;// 如果UIPickerView正在拖拽或者是正在减速，不再往下执行
    

    NSString *province = [[self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"name"];
    NSString *city = [[self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]] objectForKey:@"name"];
//    NSString *town;
//    if (self.townArray.count != 0) {
//
////        town = [self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
//
//    } else {
//
//        town = @"";
//    }
    if(province && city){
        self.selectedLocation(@[province, city]);
    }
    [self remove];
}

//选择的数组
- (void)reloadata {
//    NSString *province = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
//    NSString *city = [self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
//    NSString *town;
//    if (self.townArray.count != 0) {
//        
//        NSInteger index = [self.pickerView selectedRowInComponent:2];
//        if (index > self.townArray.count - 1) {
//            index = self.townArray.count - 1;
//        }
//        town = [self.townArray objectAtIndex:index];
//        
//    } else {
//        
//        town = @"";
//    }
//    self.toolBar.title = [[province stringByAppendingString:[NSString stringWithFormat:@" %@", city]] stringByAppendingString:[NSString stringWithFormat:@" %@", town]];
}

- (void)show {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    #pragma clang diagnostic pop
    
    CGRect frameTool = self.toolbar.frame;
    frameTool.origin.y -= PickerViewHeight;
    
    CGRect framePicker =  self.pickerView.frame;
    framePicker.origin.y -= PickerViewHeight;
    [UIView animateWithDuration:0.33 animations:^{
        [self.layer setOpacity:1];
        self.toolbar.frame = frameTool;
        self.pickerView.frame = framePicker;
    } completion:^(BOOL finished) {
    }];
}

- (void)remove {
    CGRect frameTool = self.toolbar.frame;
    frameTool.origin.y += PickerViewHeight;
    
    CGRect framePicker =  self.pickerView.frame;
    framePicker.origin.y += PickerViewHeight ;
    [UIView animateWithDuration:0.33 animations:^{
        [self.layer setOpacity:0];
        self.toolbar.frame = frameTool;
        self.pickerView.frame = framePicker;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat pickerW = [UIScreen mainScreen].bounds.size.width;
        CGFloat pickerH = PickerViewHeight   - 44;
        CGFloat pickerX = 0;
        CGFloat pickerY = [UIScreen mainScreen].bounds.size.height + 44;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}

- (HToolBar *)toolbar {
    if (!_toolBar) {
        _toolBar = [[HToolBar alloc]initWithTitle:@"城市"
                                 cancelButtonTitle:@"取消"
                                     confirmButtonTitle:@"确定"
                                         addTarget:self
                                      cancelAction:@selector(cancelAction)
                                          confirmAction:@selector(confirmAction)];
        CGRect frame = self.bounds;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        _toolBar.frame = frame;
    }
    return _toolBar;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [_lineView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        #pragma clang diagnostic pop
    }
    return _lineView;
}

@end
