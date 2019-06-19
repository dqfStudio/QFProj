//
//  UIScrollView+HEmptyDataSet.m
//  QFProj
//
//  Created by dqf on 2018/5/19.
//  Copyright © 2018年 dqfStudio. All rights reserved.
//

#import "UIScrollView+HEmptyDataSet.h"
#import <objc/runtime.h>

@interface UIView (HConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)hEquallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;

@end

@interface HWeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;

- (instancetype)initWithWeakObject:(id)object;

@end

@interface HEmptyDataSetView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;
- (void)prepareForReuse;

@end


#pragma mark - UIScrollView+EmptyDataSet

static char const * const kHEmptyDataSetSource =     "emptyDataSetSource";
static char const * const kHEmptyDataSetDelegate =   "emptyDataSetDelegate";
static char const * const kHEmptyDataSetView =       "emptyDataSetView";

#define kHEmptyImageViewAnimationKey @"com.dzn.emptyDataSet.imageViewAnimation"

@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) HEmptyDataSetView *hEmptyDataSetView;
@end

@implementation UIScrollView (HEmptyDataSet)

#pragma mark - Getters (Public)

- (id<HEmptyDataSetSource>)hEmptyDataSetSource {
    HWeakObjectContainer *container = objc_getAssociatedObject(self, kHEmptyDataSetSource);
    return container.weakObject;
}

- (id<HEmptyDataSetDelegate>)hEmptyDataSetDelegate {
    HWeakObjectContainer *container = objc_getAssociatedObject(self, kHEmptyDataSetDelegate);
    return container.weakObject;
}

- (BOOL)isHEmptyDataSetVisible {
    UIView *view = objc_getAssociatedObject(self, kHEmptyDataSetView);
    return view ? !view.hidden : NO;
}


#pragma mark - Getters (Private)

- (HEmptyDataSetView *)hEmptyDataSetView {
    HEmptyDataSetView *view = objc_getAssociatedObject(self, kHEmptyDataSetView);
    
    if (!view) {
        view = [HEmptyDataSetView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(h_didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        
        [self setHEmptyDataSetView:view];
    }
    return view;
}

- (BOOL)h_canDisplay {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource conformsToProtocol:@protocol(HEmptyDataSetSource)]) {
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSInteger)h_itemsCount {
    NSInteger items = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView support
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView support
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;

        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    
    return items;
}


#pragma mark - Data Source Getters

- (NSAttributedString *)h_titleLabelString {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(hTitleForEmptyDataSethTitleForEmptyDataSet:)]) {
        NSAttributedString *string = [self.hEmptyDataSetSource titleForEmptyDataSet:self];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -titleForEmptyDataSet:");
        return string;
    }
    return nil;
}

- (NSAttributedString *)h_detailLabelString {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(descriptionForEmptyDataSet:)]) {
        NSAttributedString *string = [self.hEmptyDataSetSource descriptionForEmptyDataSet:self];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -descriptionForEmptyDataSet:");
        return string;
    }
    return nil;
}

- (UIImage *)h_image {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(hImageForEmptyDataSethImageForEmptyDataSet:)]) {
        UIImage *image = [self.hEmptyDataSetSource imageForEmptyDataSet:self];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -imageForEmptyDataSet:");
        return image;
    }
    return nil;
}

- (CAAnimation *)h_imageAnimation {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(imageAnimationForEmptyDataSet:)]) {
        CAAnimation *imageAnimation = [self.hEmptyDataSetSource imageAnimationForEmptyDataSet:self];
        if (imageAnimation) NSAssert([imageAnimation isKindOfClass:[CAAnimation class]], @"You must return a valid CAAnimation object for -imageAnimationForEmptyDataSet:");
        return imageAnimation;
    }
    return nil;
}

- (UIColor *)h_imageTintColor {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(imageTintColorForEmptyDataSet:)]) {
        UIColor *color = [self.hEmptyDataSetSource imageTintColorForEmptyDataSet:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -imageTintColorForEmptyDataSet:");
        return color;
    }
    return nil;
}

- (NSAttributedString *)h_buttonTitleForState:(UIControlState)state {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(buttonTitleForEmptyDataSet:forState:)]) {
        NSAttributedString *string = [self.hEmptyDataSetSource buttonTitleForEmptyDataSet:self forState:state];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -buttonTitleForEmptyDataSet:forState:");
        return string;
    }
    return nil;
}

- (UIImage *)h_buttonImageForState:(UIControlState)state {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(buttonImageForEmptyDataSet:forState:)]) {
        UIImage *image = [self.hEmptyDataSetSource buttonImageForEmptyDataSet:self forState:state];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonImageForEmptyDataSet:forState:");
        return image;
    }
    return nil;
}

- (UIImage *)h_buttonBackgroundImageForState:(UIControlState)state {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(buttonBackgroundImageForEmptyDataSet:forState:)]) {
        UIImage *image = [self.hEmptyDataSetSource buttonBackgroundImageForEmptyDataSet:self forState:state];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonBackgroundImageForEmptyDataSet:forState:");
        return image;
    }
    return nil;
}

- (UIColor *)h_dataSetBackgroundColor {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(backgroundColorForEmptyDataSet:)]) {
        UIColor *color = [self.hEmptyDataSetSource backgroundColorForEmptyDataSet:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -backgroundColorForEmptyDataSet:");
        return color;
    }
    return [UIColor clearColor];
}

- (UIView *)h_customView {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(customViewForEmptyDataSet:)]) {
        UIView *view = [self.hEmptyDataSetSource customViewForEmptyDataSet:self];
        if (view) NSAssert([view isKindOfClass:[UIView class]], @"You must return a valid UIView object for -customViewForEmptyDataSet:");
        return view;
    }
    return nil;
}

- (CGFloat)h_verticalOffset {
    CGFloat offset = 0.0;
    
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(verticalOffsetForEmptyDataSet:)]) {
        offset = [self.hEmptyDataSetSource verticalOffsetForEmptyDataSet:self];
    }
    return offset;
}

- (CGFloat)h_verticalSpace {
    if (self.hEmptyDataSetSource && [self.hEmptyDataSetSource respondsToSelector:@selector(spaceHeightForEmptyDataSet:)]) {
        return [self.hEmptyDataSetSource spaceHeightForEmptyDataSet:self];
    }
    return 0.0;
}


#pragma mark - Delegate Getters & Events (Private)

- (BOOL)h_shouldFadeIn {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldFadeIn:)]) {
        return [self.hEmptyDataSetDelegate emptyDataSetShouldFadeIn:self];
    }
    return YES;
}

- (BOOL)h_shouldDisplay {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldDisplay:)]) {
        return [self.hEmptyDataSetDelegate emptyDataSetShouldDisplay:self];
    }
    return YES;
}

- (BOOL)h_shouldBeForcedToDisplay {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldBeForcedToDisplay:)]) {
        return [self.hEmptyDataSetDelegate emptyDataSetShouldBeForcedToDisplay:self];
    }
    return NO;
}

- (BOOL)h_isTouchAllowed {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAllowTouch:)]) {
        return [self.hEmptyDataSetDelegate emptyDataSetShouldAllowTouch:self];
    }
    return YES;
}

- (BOOL)h_isScrollAllowed {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(hEmptyDataSetShouldAllowScrollhEmptyDataSetShouldAllowScroll:)]) {
        return [self.hEmptyDataSetDelegate emptyDataSetShouldAllowScroll:self];
    }
    return NO;
}

- (BOOL)h_isImageViewAnimateAllowed {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetShouldAnimateImageView:)]) {
        return [self.hEmptyDataSetDelegate emptyDataSetShouldAnimateImageView:self];
    }
    return NO;
}

- (void)h_willAppear {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetWillAppear:)]) {
        [self.hEmptyDataSetDelegate emptyDataSetWillAppear:self];
    }
}

- (void)h_didAppear {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidAppear:)]) {
        [self.hEmptyDataSetDelegate emptyDataSetDidAppear:self];
    }
}

- (void)h_willDisappear {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetWillDisappear:)]) {
        [self.hEmptyDataSetDelegate emptyDataSetWillDisappear:self];
    }
}

- (void)h_didDisappear {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidDisappear:)]) {
        [self.hEmptyDataSetDelegate emptyDataSetDidDisappear:self];
    }
}

- (void)h_didTapContentView:(id)sender {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSet:didTapView:)]) {
        [self.hEmptyDataSetDelegate emptyDataSet:self didTapView:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapView:)]) {
        [self.hEmptyDataSetDelegate emptyDataSetDidTapView:self];
    }
#pragma clang diagnostic pop
}

- (void)h_didTapDataButton:(id)sender {
    if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSet:didTapButton:)]) {
        [self.hEmptyDataSetDelegate emptyDataSet:self didTapButton:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (self.hEmptyDataSetDelegate && [self.hEmptyDataSetDelegate respondsToSelector:@selector(emptyDataSetDidTapButton:)]) {
        [self.hEmptyDataSetDelegate emptyDataSetDidTapButton:self];
    }
#pragma clang diagnostic pop
}


#pragma mark - Setters (Public)

- (void)setHEmptyDataSetSource:(id<HEmptyDataSetSource>)datasource {
    if (!datasource || ![self h_canDisplay]) {
        [self h_invalidate];
    }
    
    objc_setAssociatedObject(self, kHEmptyDataSetSource, [[HWeakObjectContainer alloc] initWithWeakObject:datasource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // We add method sizzling for injecting -h_reloadData implementation to the native -reloadData implementation
    [self hSwizzleIfPossible:@selector(reloadData)];
    
    // Exclusively for UITableView, we also inject -h_reloadData to -endUpdates
    if ([self isKindOfClass:[UITableView class]]) {
        [self hSwizzleIfPossible:@selector(endUpdates)];
    }
}

- (void)setHEmptyDataSetDelegate:(id<HEmptyDataSetDelegate>)delegate {
    if (!delegate) {
        [self h_invalidate];
    }
    
    objc_setAssociatedObject(self, kHEmptyDataSetDelegate, [[HWeakObjectContainer alloc] initWithWeakObject:delegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Setters (Private)

- (void)setHEmptyDataSetView:(HEmptyDataSetView *)view {
    objc_setAssociatedObject(self, kHEmptyDataSetView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Reload APIs (Public)

- (void)hReloadEmptyDataSet {
    [self h_reloadEmptyDataSet];
}


#pragma mark - Reload APIs (Private)

- (void)h_reloadEmptyDataSet {
    if (![self h_canDisplay]) {
        return;
    }
    
    if (([self h_shouldDisplay] && [self h_itemsCount] == 0) || [self h_shouldBeForcedToDisplay]) {
        // Notifies that the empty dataset view will appear
        [self h_willAppear];
        
        HEmptyDataSetView *view = self.hEmptyDataSetView;
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }
            else {
                [self addSubview:view];
            }
        }
        
        // Removing view resetting the view and its constraints it very important to guarantee a good state
        [view prepareForReuse];
        
        UIView *customView = [self h_customView];
        
        // If a non-nil custom view is available, let's configure it instead
        if (customView) {
            view.customView = customView;
        }
        else {
            // Get the data from the data source
            NSAttributedString *titleLabelString = [self h_titleLabelString];
            NSAttributedString *detailLabelString = [self h_detailLabelString];
            
            UIImage *buttonImage = [self h_buttonImageForState:UIControlStateNormal];
            NSAttributedString *buttonTitle = [self h_buttonTitleForState:UIControlStateNormal];
            
            UIImage *image = [self h_image];
            UIColor *imageTintColor = [self h_imageTintColor];
            UIImageRenderingMode renderingMode = imageTintColor ? UIImageRenderingModeAlwaysTemplate : UIImageRenderingModeAlwaysOriginal;
            
            view.verticalSpace = [self h_verticalSpace];
            
            // Configure Image
            if (image) {
                if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
                    view.imageView.image = [image imageWithRenderingMode:renderingMode];
                    view.imageView.tintColor = imageTintColor;
                }
                else {
                    // iOS 6 fallback: insert code to convert imaged if needed
                    view.imageView.image = image;
                }
            }
            
            // Configure title label
            if (titleLabelString) {
                view.titleLabel.attributedText = titleLabelString;
            }
            
            // Configure detail label
            if (detailLabelString) {
                view.detailLabel.attributedText = detailLabelString;
            }
            
            // Configure button
            if (buttonImage) {
                [view.button setImage:buttonImage forState:UIControlStateNormal];
                [view.button setImage:[self h_buttonImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
            else if (buttonTitle) {
                [view.button setAttributedTitle:buttonTitle forState:UIControlStateNormal];
                [view.button setAttributedTitle:[self h_buttonTitleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
                [view.button setBackgroundImage:[self h_buttonBackgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
                [view.button setBackgroundImage:[self h_buttonBackgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
        }
        
        // Configure offset
        view.verticalOffset = [self h_verticalOffset];
        
        // Configure the empty dataset view
        view.backgroundColor = [self h_dataSetBackgroundColor];
        view.hidden = NO;
        view.clipsToBounds = YES;
        
        // Configure empty dataset userInteraction permission
        view.userInteractionEnabled = [self h_isTouchAllowed];
        
        // Configure empty dataset fade in display
        view.fadeInOnDisplay = [self h_shouldFadeIn];
        
        [view setupConstraints];
        
        [UIView performWithoutAnimation:^{
            [view layoutIfNeeded];            
        }];
        
        // Configure scroll permission
        self.scrollEnabled = [self h_isScrollAllowed];
        
        // Configure image view animation
        if ([self h_isImageViewAnimateAllowed])
        {
            CAAnimation *animation = [self h_imageAnimation];
            
            if (animation) {
                [self.hEmptyDataSetView.imageView.layer addAnimation:animation forKey:kHEmptyImageViewAnimationKey];
            }
        }
        else if ([self.hEmptyDataSetView.imageView.layer animationForKey:kHEmptyImageViewAnimationKey]) {
            [self.hEmptyDataSetView.imageView.layer removeAnimationForKey:kHEmptyImageViewAnimationKey];
        }
        
        // Notifies that the empty dataset view did appear
        [self h_didAppear];
    }
    else if (self.isHEmptyDataSetVisible) {
        [self h_invalidate];
    }
}

- (void)h_invalidate {
    // Notifies that the empty dataset view will disappear
    [self h_willDisappear];
    
    if (self.hEmptyDataSetView) {
        [self.hEmptyDataSetView prepareForReuse];
        [self.hEmptyDataSetView removeFromSuperview];
        
        [self setHEmptyDataSetView:nil];
    }
    
    self.scrollEnabled = YES;
    
    // Notifies that the empty dataset view did disappear
    [self h_didDisappear];
}


#pragma mark - Method Swizzling

static NSMutableDictionary *_hImpLookupTable;
static NSString *const HSwizzleInfoPointerKey = @"pointer";
static NSString *const HSwizzleInfoOwnerKey = @"owner";
static NSString *const HSwizzleInfoSelectorKey = @"selector";

void h_original_implementation(id self, SEL _cmd) {
    // Fetch original implementation from lookup table
    Class baseClass = h_baseClassToSwizzleForTarget(self);
    NSString *key = h_implementationKey(baseClass, _cmd);
    
    NSDictionary *swizzleInfo = [_hImpLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:HSwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // We then inject the additional implementation for reloading the empty dataset
    // Doing it before calling the original implementation does update the 'isEmptyDataSetVisible' flag on time.
    [self h_reloadEmptyDataSet];
    
    // If found, call original implementation
    if (impPointer) {
        ((void(*)(id,SEL))impPointer)(self,_cmd);
    }
}

NSString *h_implementationKey(Class class, SEL selector) {
    if (!class || !selector) {
        return nil;
    }
    
    NSString *className = NSStringFromClass([class class]);
    
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}

Class h_baseClassToSwizzleForTarget(id target) {
    if ([target isKindOfClass:[UITableView class]]) {
        return [UITableView class];
    }
    else if ([target isKindOfClass:[UICollectionView class]]) {
        return [UICollectionView class];
    }
    else if ([target isKindOfClass:[UIScrollView class]]) {
        return [UIScrollView class];
    }
    
    return nil;
}

- (void)hSwizzleIfPossible:(SEL)selector {
    // Check if the target responds to selector
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    // Create the lookup table
    if (!_hImpLookupTable) {
        _hImpLookupTable = [[NSMutableDictionary alloc] initWithCapacity:3]; // 3 represent the supported base classes
    }
    
    // We make sure that setImplementation is called once per class kind, UITableView or UICollectionView.
    for (NSDictionary *info in [_hImpLookupTable allValues]) {
        Class class = [info objectForKey:HSwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:HSwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    Class baseClass = h_baseClassToSwizzleForTarget(self);
    NSString *key = h_implementationKey(baseClass, selector);
    NSValue *impValue = [[_hImpLookupTable objectForKey:key] valueForKey:HSwizzleInfoPointerKey];
    
    // If the implementation for this class already exist, skip!!
    if (impValue || !key || !baseClass) {
        return;
    }
    
    // Swizzle by injecting additional implementation
    Method method = class_getInstanceMethod(baseClass, selector);
    IMP h_newImplementation = method_setImplementation(method, (IMP)h_original_implementation);
    
    // Store the new implementation in the lookup table
    NSDictionary *swizzledInfo = @{HSwizzleInfoOwnerKey: baseClass,
                                   HSwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   HSwizzleInfoPointerKey: [NSValue valueWithPointer:h_newImplementation]};
    
    [_hImpLookupTable setObject:swizzledInfo forKey:key];
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isEqual:self.hEmptyDataSetView]) {
        return [self h_isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIGestureRecognizer *tapGesture = self.hEmptyDataSetView.tapGesture;
    
    if ([gestureRecognizer isEqual:tapGesture] || [otherGestureRecognizer isEqual:tapGesture]) {
        return YES;
    }
    
    // defer to emptyDataSetDelegate's implementation if available
    if ( (self.hEmptyDataSetDelegate != (id)self) && [self.hEmptyDataSetDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [(id)self.hEmptyDataSetDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    
    return NO;
}

@end


#pragma mark - DZNEmptyDataSetView

@interface HEmptyDataSetView ()
@end

@implementation HEmptyDataSetView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

#pragma mark - Initialization Methods

- (instancetype)init {
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview {
    self.frame = self.superview.bounds;
    
    void(^fadeInBlock)(void) = ^{self->_contentView.alpha = 1.0;};
    
    if (self.fadeInOnDisplay) {
        [UIView animateWithDuration:0.25
                         animations:fadeInBlock
                         completion:NULL];
    }
    else {
        fadeInBlock();
    }
}


#pragma mark - Getters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"empty set background image";
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
        
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        
        _detailLabel.font = [UIFont systemFontOfSize:17.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"empty set detail label";
        
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.backgroundColor = [UIColor clearColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"empty set button";
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_button];
    }
    return _button;
}

- (BOOL)canShowImage {
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle {
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail {
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton {
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil);
    }
    return NO;
}


#pragma mark - Setters

- (void)setCustomView:(UIView *)view {
    if (!view) {
        return;
    }
    
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender {
    SEL selector = NSSelectorFromString(@"h_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}

- (void)removeAllConstraints {
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

- (void)prepareForReuse {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
    
    [self removeAllConstraints];
}


#pragma mark - Auto-Layout Configuration

- (void)setupConstraints {
    // First, configure the content view constaints
    // The content view must alway be centered to its superview
    NSLayoutConstraint *centerXConstraint = [self hEquallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *centerYConstraint = [self hEquallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY];
    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
    
    // When a custom offset is available, we adjust the vertical constraints' constants
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerYConstraint.constant = self.verticalOffset;
    }
    
    // If applicable, set the custom view's constraints
    if (_customView) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
    }
    else {
        CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat padding = roundf(width/16.0);
        CGFloat verticalSpace = self.verticalSpace ? : 11.0; // Default is 11 pts
        
        NSMutableArray *subviewStrings = [NSMutableArray array];
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        NSDictionary *metrics = @{@"padding": @(padding)};
        
        // Assign the image view's horizontal constraints
        if (_imageView.superview) {
            
            [subviewStrings addObject:@"imageView"];
            views[[subviewStrings lastObject]] = _imageView;
            
            [self.contentView addConstraint:[self.contentView hEquallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }
        
        // Assign the title label's horizontal constraints
        if ([self canShowTitle]) {
            
            [subviewStrings addObject:@"titleLabel"];
            views[[subviewStrings lastObject]] = _titleLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        // Assign the detail label's horizontal constraints
        if ([self canShowDetail]) {
            
            [subviewStrings addObject:@"detailLabel"];
            views[[subviewStrings lastObject]] = _detailLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        // Assign the button's horizontal constraints
        if ([self canShowButton]) {
            
            [subviewStrings addObject:@"button"];
            views[[subviewStrings lastObject]] = _button;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[button(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_button removeFromSuperview];
            _button = nil;
        }
        
        
        NSMutableString *verticalFormat = [NSMutableString new];
        
        // Build a dynamic string format for the vertical constraints, adding a margin between each element. Default is 11 pts.
        for (int i = 0; i < subviewStrings.count; i++) {
            
            NSString *string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];
            
            if (i < subviewStrings.count-1) {
                [verticalFormat appendFormat:@"-(%.f@750)-", verticalSpace];
            }
        }
        
        // Assign the vertical constraints to the content view
        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                     options:0 metrics:metrics views:views]];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // Return any UIControl instance such as buttons, segmented controls, switches, etc.
    if ([hitView isKindOfClass:[UIControl class]]) {
        return hitView;
    }
    
    // Return either the contentView or customView
    if ([hitView isEqual:_contentView] || [hitView isEqual:_customView]) {
        return hitView;
    }
    
    return nil;
}

@end


#pragma mark - UIView+DZNConstraintBasedLayoutExtensions

@implementation UIView (HConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)hEquallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end

#pragma mark - DZNWeakObjectContainer

@implementation HWeakObjectContainer

- (instancetype)initWithWeakObject:(id)object {
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end
