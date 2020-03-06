
#import <UIKit/UIKit.h>

@class LSUpLoadHelper;

@protocol LSUpLoadHelperDelegate <NSObject>

/**
 *  上传进度
 *
 *  @param uploadHelper 本类的实例化
 *  @param progress     上传进度
 */
- (void)ls_upLoad:(LSUpLoadHelper *)uploadHelper progress:(CGFloat)progress;

/**
 *  上传成功回调
 *
 *  @param uploadHelper 本类的实例化
 *  @param dict         成功返回字典
 */
- (void)ls_upLoad:(LSUpLoadHelper *)uploadHelper finishedWithDict:(NSDictionary *)dict;

/**
 *  上传失败回调
 *
 *  @param uploadHelper 本类的实例化
 *  @param error        错误信息
 */
- (void)ls_upLoad:(LSUpLoadHelper *)uploadHelper failedWithError:(NSError *)error;

@end

@interface LSUpLoadHelper : NSObject <NSURLConnectionDataDelegate>

@property (weak, nonatomic) id <LSUpLoadHelperDelegate> delegate;

/**
 *  根据文件路径获取文件的MIMEType
 *
 *  @param url 文件路径
 *
 *  @return 文件MIMEType
 */
- (NSString *)MIMEType:(NSURL *)url;

/**
 *  根据文件名、MIMEType、二进制文件、其他的参数上传文件
 *
 *  @param filename 文件名
 *  @param mimeType MIMEType
 *  @param fileData 二进制文件
 *  @param params   非文件的其他详细参数
 */
- (void)upload:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params;

@end
