//
//  UtilsMacro.h
//  InvestChina
//
//  Created by 闫建刚 on 14-6-1.
//  Copyright (c) 2014年 iMobile. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//方便使用的工具宏

//适配IPhone5、IOS7

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IOS_7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7)

//定义屏幕尺寸及中心坐标 定义高清屏
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kScreen_CenterX  kSCREEN_WIDTH/2
#define kScreen_CenterY  kSCREEN_HEIGHT/2
//#define isRetina ([[UIScreen mainScreen] scale]==2)

//可拉伸的图片

#define IMAGE(name) [UIImage imageNamed:name]
#define PNGIMAGE(name)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(name) ofType:@"png"]]
#define ResizableImage(name,top,left,bottom,right) [IMAGE(name) resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableScaleImage(name,zoom,top,left,bottom,right) [[UIImage imageWithCGImage:IMAGE(name).CGImage scale:zoom orientation:UIImageOrientationUp] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]

//获取view的frame某值
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y

//根据tag值获取子视图
#define ViewTag(v,t)                        [v viewWithTag:t]

// 创建rect
#define Rect(x,y,width,height)              CGRectMake(x, y, width,height)

//获取rect中某值
#define RectX(rect)                            rect.origin.x
#define RectY(rect)                            rect.origin.y
#define RectWidth(rect)                        rect.size.width
#define RectHeight(rect)                       rect.size.height
//设置rect中某值
#define RectSetWidth(rect, w)                  CGRectMake(RectX(rect), RectY(rect), w, RectHeight(rect))
#define RectSetHeight(rect, h)                 CGRectMake(RectX(rect), RectY(rect), RectWidth(rect), h)
#define RectSetX(rect, x)                      CGRectMake(x, RectY(rect), RectWidth(rect), RectHeight(rect))
#define RectSetY(rect, y)                      CGRectMake(RectX(rect), y, RectWidth(rect), RectHeight(rect))

#define RectSetSize(rect, w, h)                CGRectMake(RectX(rect), RectY(rect), w, h)
#define RectSetOrigin(rect, x, y)              CGRectMake(x, y, RectWidth(rect), RectHeight(rect))

#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f; }
#define MoveViewTo(v, deltaX, deltaY) { CGRect f = v.frame; f.origin.x += deltaX ;f.origin.y += deltaY; v.frame = f; }
#define MakeHeightTo(v, h) { CGRect f = v.frame; f.size.height = h; v.frame = f; }
#define MakeXTo(v, vx) { CGRect f = v.frame; f.origin.x = vx; v.frame = f; }
#define MakeYTo(v, vy) { CGRect f = v.frame; f.origin.y = vy; v.frame = f; }
#define MakeWidthTo(v,w)  { CGRect f = v.frame; f.size.width = w; v.frame = f; }

//  主要单例
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]

#define Bundle                              [NSBundle mainBundle]
#define BundleToObj(nibName)                [Bundle loadNibNamed:nibName owner:nil options:nil][0]
#define BundlePath(name,type)           [Bundle pathForResource:name ofType:type]

#define MainScreen                          [UIScreen mainScreen]

#define SDManager                           [SDWebImageManager sharedManager]


// 应用程序代理
#define APP_DELEGATE (AppDelegate *)SharedApplication.delegate

#define KEY_WINDOW  [SharedApplication keyWindow]

// 沙盒路径
#define PATH_FOR_CACHE    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define PATH_FOR_DOC      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define FILE_PATH_AT_CACHE(fileName)    [PATH_FOR_CACHE stringByAppendingPathComponent:fileName]
#define FILE_PATH_AT_DOC(fileName)      [PATH_FOR_DOC stringByAppendingPathComponent:fileName]

// storyboard实例化
#define STORYBOARD(storyboardName)          [UIStoryboard storyboardWithName:storyboardName bundle:nil]

#define INSTANT_VC_WITH_ID(storyboardName,vcIdentifier)  [STORYBOARD(storyboardName) instantiateViewControllerWithIdentifier:vcIdentifier]

// 主题管理器单例
#define RNTHEME_MANAGER [RNThemeManager sharedManager]

#define RN_COLOR_FOR_KEY(colorKey) [RNTHEME_MANAGER colorForKey:colorKey]

//  主要控件
#define NavBar                              self.navigationController.navigationBar
#define NavItem                             self.navigationItem
#define TabBar                              self.tabBarController.tabBar

//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]

//color
//#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//颜色转1px图片
#define PatternImageByColor(color) [UIImage imageWithColor:color]

//转换
#define I2S(number) [NSString stringWithFormat:@"%d",number]
#define F2S(number) [NSString stringWithFormat:@"%.0f",number]
#define DATE(stamp) [NSDate dateWithTimeIntervalSince1970:[stamp intValue]];

//GCD （子线程、主线程定义）
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define MAIN_DELAY(s,block) \
double delayInSeconds = s;   \
dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); \
dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);\
dispatch_after(delayInNanoSeconds, concurrentQueue, block);

//打开URL
#define canOpenURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])

#define openURL(appScheme) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]])

// 获取版本号

#ifdef DEBUG
#define LOCAL_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleVersion"]
#else
#define LOCAL_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"]
#endif

#define LOCAL_DEBUG_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleVersion"]
#define LOCAL_RELEASE_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"]

// 占位图
#define HOLDER_HEAD IMAGE(@"head_holder")

#endif
