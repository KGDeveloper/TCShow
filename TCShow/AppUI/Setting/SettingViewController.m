
//
//  SettingViewController.m
//  JShow
//
//  Created by AlexiChen on 16/2/19.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "SettingViewController.h"

#import "TLSSDK/TLSHelper.h"

#import "QALSDK/QalSDKProxy.h"

#import "MyInfoController.h"
#import "HostProfileViewController.h"
#import "XXSecurityAccountViewController.h"
#import "XXPushViewController.h"
#import "XXInviteFriendsViewController.h"
#import "XXFeedbackTableViewController.h"
#import "XXAboutAsViewController.h"
#import "XXBlacklistTableViewController.h"
#import "IMAPlatform.h"

#import <UShareUI/UShareUI.h>


//#import "XXBlacklistTableViewController.h"
@implementation SettingViewController
{
    NSArray *_titleArr1;
    NSArray *_titleArr2;
    NSArray *_titleArr3;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    _titleArr1 = @[@"个人资料",@"账号安全"];
    _titleArr2 = @[@"推送设置",@"邀请好友",@"清理缓存"];
    _titleArr3 = @[@"用户反馈",@"关于我们"];
}

- (void)addHeaderView
{
    
}

- (void)onExit
{
    [[HUDHelper sharedInstance] syncLoading:@"正在退出"];
    
//    IMAPlatform *im = [[IMAPlatform alloc] init];
//    [im logout:^{
//    } fail:^(int code, NSString *msg) {
//    }];
    [[IMAPlatform sharedInstance] logout:^{
        
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"退出成功" delay:0.5 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:@"already"];
            [SARUserInfo removeUserInfo];
            [user removeObjectForKey:@"user_login_type"];
            [user removeObjectForKey:WX_ACCESS_TOKEN];
            [user removeObjectForKey:WX_OPEN_ID];
            
            [user synchronize];
        }];
        
    } fail:^(int code, NSString *err) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err) delay:2 completion:^{
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
    }];
}


- (void)configOwnViews
{
#if kIsMeasureSpeed
    MenuItem *speed = [[MenuItem alloc] initWithTitle:@"网络测速" icon:nil action:^(id<MenuAbleItem> menu) {
        [[IMAPlatform sharedInstance] requestTestSpeed];
    }];
    [array addObject:speed];
#endif
    
    
   
    
    
    
#if kAppStoreVersion
#else
    __weak SettingViewController *ws = self;
    IMAPlatformConfig *cfg = [IMAPlatform sharedInstance].localConfig;
    
    RichCellMenuItem *testEnv = [[RichCellMenuItem alloc] initWith:@"测试环境" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSwitchEnvironment:menu cell:cell];
    }];
    testEnv.tipMargin = 20;
    testEnv.tipColor = kBlackColor;
    testEnv.valueColor = kGrayColor;
    testEnv.switchValue = cfg.environment;
    
    RichCellMenuItem *consoleLog = [[RichCellMenuItem alloc] initWith:@"控制台日志" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSwitchConsoleLog:menu cell:cell];
    }];
    consoleLog.tipMargin = 20;
    consoleLog.tipColor = kBlackColor;
    consoleLog.valueColor = kGrayColor;
    consoleLog.switchValue = cfg.enableConsoleLog;
    
    NSString *tip = [cfg getLogLevelTip];
    RichCellMenuItem *logLevel = [[RichCellMenuItem alloc] initWith:@"日志级别" value:tip type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onConsoleLevel:menu cell:cell];
    }];
    logLevel.tipMargin = 20;
    logLevel.tipColor = kBlackColor;
    logLevel.valueAlignment = NSTextAlignmentRight;
    logLevel.valueColor = kGrayColor;
    
    RichCellMenuItem *version = [[RichCellMenuItem alloc] initWith:@"SDK版本号" value:nil type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onVersionShow];
    }];
    version.tipMargin = 20;
    version.tipColor = kBlackColor;
    version.valueColor = kGrayColor;
    
    
#endif
   
}

- (void)onSwitchEnvironment:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"切换环境，下次启动时才生效。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        RichMenuTableViewCell *rcell = (RichMenuTableViewCell *)cell;
        if (buttonIndex == 1)
        {
            rcell.onSwitch.on = !rcell.onSwitch.on;
            menu.switchValue = rcell.onSwitch.on;
            [[IMAPlatform sharedInstance].localConfig chageEnvTo:rcell.onSwitch.on];
        }
        
    }];
    [alert show];
}

- (void)onSwitchConsoleLog:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"修改控制台日志，下次启动时才生效。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        RichMenuTableViewCell *rcell = (RichMenuTableViewCell *)cell;
        if (buttonIndex == 1)
        {
            IMAPlatformConfig *cfg = [IMAPlatform sharedInstance].localConfig;
            rcell.onSwitch.on = !rcell.onSwitch.on;
            [cfg chageEnableConsoleTo:rcell.onSwitch.on];
            menu.switchValue = rcell.onSwitch.on;
        }
    }];
    [alert show];
}


- (void)onConsoleLevel:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak SettingViewController *ws = self;
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"修改日志级别，下次启动时才生效。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        RichMenuTableViewCell *rcell = (RichMenuTableViewCell *)cell;
        if (buttonIndex == 1)
        {
            NSDictionary *dic = [IMAPlatformConfig logLevelTips];
            
            UIActionSheet *sheet = [[UIActionSheet alloc] init];
            
            IMAPlatformConfig *cfg = [IMAPlatform sharedInstance].localConfig;
            NSArray *array = [dic allKeys];
            for (NSString *key in array)
            {
                [sheet bk_addButtonWithTitle:key handler:^{
                    NSInteger level = (NSInteger)[(NSNumber *)[dic valueForKey:key] integerValue];
                    [cfg chageLogLevelTo:level];
                    menu.value = [cfg getLogLevelTip];
                    [rcell configWith:menu];
                }];
            }
            
            [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
            [sheet showInView:ws.view];
        }
    }];
    [alert show];
}

- (void)onVersionShow
{
    NSString *imVersion = [[TIMManager sharedInstance] GetVersion];
    NSString *tlsVersion = [[TLSHelper getInstance] getSDKVersion];
    NSString *qalVersion = [[QalSDKProxy sharedInstance] getSDKVer];
    
    NSString *myMessage = [NSString stringWithFormat:@"IMSDK Version:%@\r\nTLSSDK Version:%@\r\nQALSDK Version:%@",imVersion, tlsVersion,qalVersion];
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"SDK版本号" message:myMessage cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
    [alert show];
}


- (RichCellMenuItem *)itemOf:(NSIndexPath *)indexPath
{
    NSArray *array = _settings[@(indexPath.section)];
    RichCellMenuItem *item = array[indexPath.row];
    return item;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = RGB(69, 69, 69);
        
        if (indexPath.section == 0) {
            cell.textLabel.text = _titleArr1[indexPath.row];
        }else if (indexPath.section == 1){
            if (indexPath.row == 2) {
                for (int i = 0; i < cell.contentView.subviews.count; i++) {
                    [[cell.contentView.subviews objectAtIndex:i] removeFromSuperview];
                }
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 135, 15, 100, 20)];
                lable.text = [NSString stringWithFormat:@"%.2fM",[self filePath]];
                lable.font = [UIFont systemFontOfSize:14];
                lable.textAlignment = UITextAlignmentRight;
                lable.textColor = RGB(255, 87, 64);
                [cell.contentView addSubview:lable];
 
            }
           cell.textLabel.text = _titleArr2[indexPath.row];
        }else if (indexPath.section == 2){
            cell.textLabel.text = _titleArr3[indexPath.row];
        }else if(indexPath.section == 3){
            cell.textLabel.text = @"黑名单";
        }else{
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) * 0.5, 15, 80, 20)];
            lable.text = @"退出登录";
            lable.font = [UIFont systemFontOfSize:16];
            lable.textColor = RGB(255, 87, 64);
            [cell.contentView addSubview:lable];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        

    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
         // 个人资料
            HostProfileViewController *host = [[HostProfileViewController alloc] init];
            [self.navigationController pushViewController:host animated:YES];
            
        }else{
        // 账号安全
            XXSecurityAccountViewController *security = [[XXSecurityAccountViewController alloc] init];
            [self.navigationController pushViewController:security animated:YES];
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 推送设置
            XXPushViewController *push = [[XXPushViewController alloc] init];
            [self.navigationController pushViewController:push animated:YES];
        }else if (indexPath.row == 1){
        // 邀请好友
            XXInviteFriendsViewController *inviteFriends = [[XXInviteFriendsViewController alloc] init];
            [self.navigationController pushViewController:inviteFriends animated:YES];
        }else{
           // 清理缓存
            [self clearFile];
            
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            XXFeedbackTableViewController *feedback = [[XXFeedbackTableViewController alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
            // 用户反馈
        }else{
        // 关于我们
            
//            XXInviteFriendsViewController *inviteFriends = [[XXInviteFriendsViewController alloc] init];
//            [self.navigationController pushViewController:inviteFriends animated:YES];

            XXAboutAsViewController *about = [[XXAboutAsViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
       
    }else if (indexPath.section == 3){
        // 黑名单
        XXBlacklistTableViewController *black = [[XXBlacklistTableViewController alloc] init];
        [self.navigationController pushViewController:black animated:YES];

    }else{

       // 退出登录

        [self onExit];

    }
  
}

-(void)onSwitchShare{
    //    TCLiveShareView * shareView = [[[NSBundle mainBundle] loadNibNamed:@"TCLiveShareView" owner:nil options:nil] firstObject];
    //    shareView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    //    shareView.shareItem = ^(NSInteger itemTag){
    //        NSArray * itemArray = @[@"微博",@"QQ",@"空间",@"微信"];
    //        [[HUDHelper sharedInstance] tipMessage:itemArray[itemTag]];
    //    };
    //    [self.superview addSubview:shareView];
    __weak typeof(self) weakself = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakself shareWebPageToPlatformType:platformType];
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage *image = [UIImage imageNamed:@"shareIcon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"柠檬直播" descr:@"大家好,我正在直播哦!喜欢我的朋友赶紧来哦" thumImage:image];
    //设置网页地址
    shareObject.webpageUrl =@"https://www.pgyer.com/Lmmh";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
        }else{
        }
    }];
}


// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}

//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}

//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

// 清理缓存

- ( void ) clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-( void ) clearCachSuccess
{
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:2 inSection:1];//刷新
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}


@end
