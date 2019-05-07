//
//  HTextMagnifier.h
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import "HTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

/// Magnifier type
typedef NS_ENUM(NSInteger, HTextMagnifierType) {
    HTextMagnifierTypeCaret,  ///< Circular magnifier
    HTextMagnifierTypeRanged, ///< Round rectangle magnifier
};

/**
 A magnifier view which can be displayed in `HTextEffectWindow`.
 
 @discussion Use `magnifierWithType:` to create instance.
 Typically, you should not use this class directly.
 */
@interface HTextMagnifier : UIView

/// Create a mangifier with the specified type. @param type The magnifier type.
+ (id)magnifierWithType:(HTextMagnifierType)type;

@property (nonatomic, readonly) HTextMagnifierType type;  ///< Type of magnifier
@property (nonatomic, readonly) CGSize fitSize;            ///< The 'best' size for magnifier view.
@property (nonatomic, readonly) CGSize snapshotSize;       ///< The 'best' snapshot image size for magnifier.
@property (nullable, nonatomic, strong) UIImage *snapshot; ///< The image in magnifier (readwrite).

@property (nullable, nonatomic, weak) UIView *hostView;   ///< The coordinate based view.
@property (nonatomic) CGPoint hostCaptureCenter;          ///< The snapshot capture center in `hostView`.
@property (nonatomic) CGPoint hostPopoverCenter;          ///< The popover center in `hostView`.
@property (nonatomic) BOOL hostVerticalForm;              ///< The host view is vertical form.
@property (nonatomic) BOOL captureDisabled;               ///< A hint for `HTextEffectWindow` to disable capture.
@property (nonatomic) BOOL captureFadeAnimation;          ///< Show fade animation when the snapshot image changed.
@end

NS_ASSUME_NONNULL_END
