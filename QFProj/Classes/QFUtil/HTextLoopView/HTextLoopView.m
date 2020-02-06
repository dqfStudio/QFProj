//
//  HTextLoopView.m
//  QFProj
//
//  Created by wind on 2020/1/31.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTextLoopView.h"

@interface HTextLoopView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSTimeInterval interval;

@property (nonatomic) NSTimer *myTimer;
@property (nonatomic) NSInteger currentRowIndex;
@property (nonatomic, copy) HSelectTextBlock selectBlock;

@end

@implementation HTextLoopView

#pragma mark - 初始化方法
+ (instancetype)textLoopViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource interval:(NSTimeInterval)interval selectBlock:(HSelectTextBlock)selectBlock {
    HTextLoopView *loopView = [[HTextLoopView alloc] initWithFrame:frame];
    loopView.dataSource = dataSource;
    loopView.selectBlock = selectBlock;
    loopView.interval = interval ? interval : 1.0;
    return loopView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = frame.size.height;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setUserInteractionEnabled:NO];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.scrollsToTop = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAndRestart) name:UIApplicationDidBecomeActiveNotification object:nil];
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - priviate method
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)backAndRestart {
    [self timer];
}
- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}

- (void)timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        ++self.currentRowIndex;
        if (self.currentRowIndex >= self.dataSource.count) {
            self.currentRowIndex = 0;
        }
        [self.tableView setContentOffset:CGPointMake(0, self.currentRowIndex*self.tableView.rowHeight) animated:YES];
    });
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"HTextLoopViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor lightTextColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectBlock) {
        self.selectBlock(_dataSource[indexPath.row], indexPath.row);
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 以无动画的形式跳到第1组的第0行
    if (_currentRowIndex == _dataSource.count) {
        _currentRowIndex = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setContentOffset:CGPointZero];
        });
    }
}

#pragma mark - touch method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_selectBlock) {
        if (_currentRowIndex >= _dataSource.count) {
            _currentRowIndex = 0;
        }
        self.selectBlock(_dataSource[_currentRowIndex], _currentRowIndex);
    }
}

@end
