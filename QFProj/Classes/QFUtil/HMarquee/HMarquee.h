//
//  HMarquee.h
//  Wonderful
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HMarqueeSpeedLevel) {
    HMarqueeSpeedLevelFast       = 2,
    HMarqueeSpeedLevelMediumFast = 4,
    HMarqueeSpeedLevelMediumSlow = 6,
    HMarqueeSpeedLevelSlow       = 8,
};

@interface HMarquee : UIView

// 滚动文字 修改源码，防止出来可以在接口调用完成后动态设置显示文案
@property (nonatomic,copy  ) NSString             *msg;

/**
 *  style is default, backgroundColor is white,textColor is black;
 *
 *  @param speed you can set 2,4,6,8.  smaller is faster
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame speed:(HMarqueeSpeedLevel)speed Msg:(NSString *)msg ;

/**
 *  style is diy, backgroundColor and textColor can config
 *
 *  @param speed  you can set 2,4,6,8.  smaller is faster
 *  @param bgColor  backgroundColor
 *  @param txtColor textColor
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame speed:(HMarqueeSpeedLevel)speed Msg:(NSString *)msg bgColor:(UIColor *)bgColor txtColor:(UIColor *)txtColor;

/**
 *  you can change the tapAction show or jump, without this method default is tap to stop
 *
 *  @param action tapAction block code
 */
- (void)changeTapMarqueeAction:(void(^)(void))action;

/**
 *  you can change marqueeLabel 's font before start
 *
 */
- (void)changeMarqueeLabelFont:(UIFont *)font;

/**
 *  when you set everything what you want,you can use this method to begin animate
 */
- (void)start;

/**
 *  pause
 */
- (void)stop;

/**
 *  will start with the point we stoped.
 */
- (void)restart;

@end
