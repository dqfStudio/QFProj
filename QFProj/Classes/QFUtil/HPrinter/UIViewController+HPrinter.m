//
//  UIViewController+HPrinter.m
//  QFProj
//
//  Created by dqf on 2020/3/6.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "UIViewController+HPrinter.h"
#import "NSObject+HSwizzleUtil.h"

#if DEBUG

@implementation UIViewController (HPrinter)
- (NSMutableArray *)allVCViews {
    NSMutableArray *allVCViews = objc_getAssociatedObject(self, _cmd);
    if (!allVCViews) {
        allVCViews = [NSMutableArray array];
        self.allVCViews = allVCViews;
    }
    return allVCViews;
}
- (void)setAllVCViews:(NSMutableArray *)allVCViews {
    objc_setAssociatedObject(self, @selector(allVCViews), allVCViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] methodSwizzleWithOrigSEL:@selector(viewDidAppear:) overrideSEL:@selector(snapshot_viewDidAppear:)];
//    });
//}
- (void)snapshot_viewDidAppear:(BOOL)animated {
    [self snapshot_viewDidAppear:animated];
    [self beginImageWithView:self.view];
}
- (void)beginImageWithView:(UIView *)view {
    if (![self isSysClass:self.class] && ![self isKindOfClass:UINavigationController.class]) {
        NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"SnapshotImages"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
        if (!(isDir && existed)) {
            [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        dataFilePath = [dataFilePath stringByAppendingFormat:@"/%@.jpg", NSStringFromClass(self.class)];
        if (![self.allVCViews containsObject:dataFilePath]) {
            [self.allVCViews addObject:dataFilePath];
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
            // 方法一 有时导航条无法正常获取
            // [view.layer renderInContext:UIGraphicsGetCurrentContext()];
            // 方法二 iOS7.0 后推荐使用
            [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            //NSData *data = UIImagePNGRepresentation(viewImage);
            NSData *data = UIImageJPEGRepresentation(viewImage, 0.9);
            [data writeToFile:dataFilePath atomically:YES];
            UIGraphicsEndImageContext();
        }
    }
}
- (BOOL)isSysClass:(Class)aClass {
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    if ([bundle isEqual:[NSBundle mainBundle]]) {
        return NO;
    }else {
        return YES;
    }
}
@end

#endif
