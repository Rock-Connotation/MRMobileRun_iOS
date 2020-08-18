//
//  ZYLPersonalViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import "ZYLPersonalViewController.h"
#import "ZYLLoginViewController.h"
#import "ZYLSettingBackgound.h"
#import "ZYLUploadAvatar.h"
#import "ZYLChangeNickname.h"
#import "ZYLPhotoSelectedVIew.h"
#import "ZYLAvatarRequest.h"
#import "MRTabBarController.h"
#import <MBProgressHUD.h>
#import <MGJRouter.h>
#import "YYZCommentViewController.h"
#import "YYZTextViewController.h"
#import "AboutViewController.h"
#import "SportSettingViewController.h"
@interface ZYLPersonalViewController () <UITextFieldDelegate>

//@property (strong, nonatomic) ZYLPersonalInformationView *personalInformationView;
@property (nonatomic, strong) ZYLSettingBackgound *bkgView;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableDictionary *nicknameDic;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation ZYLPersonalViewController

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden: NO];
//    设置透明导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]}; // title颜色
    self.title = @"设置";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
//    [self.view addSubview: self.personalInformationView];
    [ZYLAvatarRequest ZYLGetAvatar];
    [self.view addSubview: self.bkgView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:)  name:@"getAvatar" object:nil];
//    NSData *imageData = [[NSData alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myAvatar:)  name:@"getAvatarSuccess" object: nil];
    
    UIButton *textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       textBtn.frame = CGRectMake(0, 240, 400, 60);
       textBtn.backgroundColor = [UIColor clearColor];
       [textBtn addTarget:self action:@selector(actionText) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:textBtn];
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(0, 300, 400, 60);
    aboutBtn.backgroundColor = [UIColor clearColor];
    [aboutBtn addTarget:self action:@selector(actionAbout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutBtn];
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 370, 400, 60);
    settingBtn.backgroundColor = [UIColor clearColor];
    [settingBtn addTarget:self action:@selector(actionSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(0, 433, 400, 60);
    commentBtn.backgroundColor = [UIColor clearColor];
    [commentBtn addTarget:self action:@selector(actionComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentBtn];
    
    /*UIButton *darkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    darkBtn.frame = CGRectMake(305, 515, 60, 35);
    darkBtn.backgroundColor = [UIColor clearColor];
    [darkBtn addTarget:self action:@selector(actionDark) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:darkBtn];*/
    
}

- (void)actionText{
    YYZTextViewController *vc1 =[[YYZTextViewController alloc]init];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)actionAbout{
    AboutViewController *vc1 =[[AboutViewController alloc]init];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)actionSetting{
    SportSettingViewController *vc1 =[[SportSettingViewController alloc]init];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)actionComment{
    YYZCommentViewController *vc1 =[[YYZCommentViewController alloc]init];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)clickLogoutBtu{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBar" object:nil];
//    NSDictionary *dic = [self.userDefaults dictionaryRepresentation];
//    for (id key in dic)
//    {
//        if ([key isEqual:@"studentID"] || [key isEqual:@"password"] ||  [key isEqual:@"nickname"] || [key isEqual:@"class_id"] || [key isEqual:@"token"])
//        {
//            NSLog(@"非空%@ is %@",key,[self.userDefaults objectForKey:key]);
//            [self.userDefaults removeObjectForKey:key];
//        }
//        else
//        {
//            NSLog(@"空%@ is %@",key,[self.userDefaults objectForKey:key]);
//        }
//    }
//    [self.userDefaults synchronize];
    [MGJRouter openURL:kLoginVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
}

- (void)myAvatar:(NSNotification *)notification{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    UIImage *avatar =  [UIImage imageWithData: [user objectForKey:@"myAvatar"] scale:1];
    self.imageView.image = avatar;
    [self.bkgView.iconCell.iconButton setImage:avatar forState:UIControlStateNormal];
}

- (void)clickAvatarBtu{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageWithData: [defaults objectForKey:@"myAvatar"]];
    ZYLPhotoSelectedVIew *selectView = [ZYLPhotoSelectedVIew selectViewWithDestinationImageView: self.imageView delegate:self];
    selectView.iconImage = self.imageView.image;
    [self.view addSubview:selectView];
}

- (void)getAvatar:(NSNotification*)notification{
    NSLog(@"\n\n\n\n获取成功\n\n\n\n");
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1);
//    //        将图片存储在本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:imageData forKey: @"myAvatar"];
    [defaults synchronize];
    [self.bkgView.iconCell.iconButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];


    [ZYLUploadAvatar UpdateAvatarWithImage:self.imageView.image];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改昵称" message:@"请在下方文本框内输入新的昵称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){

    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nickName = alertController.textFields.firstObject;
        if (![nickName.text isEqualToString:@""]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:nickName.text forKey:@"nickname"];
            self.bkgView.nicknameCell.nicknameTextFiled.text = nickName.text;
            self.nicknameDic = [[NSMutableDictionary alloc]init];
            [self.nicknameDic setObject:self.bkgView.nicknameCell.nicknameTextFiled.text forKey:@"nickname"];
            [ZYLChangeNickname uploadChangedNickname:nickName.text];
        }
    }];

    [okAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

    return NO;
}

#pragma mark - 懒加载
- (ZYLSettingBackgound *)bkgView{
    if (!_bkgView) {
        _bkgView = [[ZYLSettingBackgound alloc] init];
        _bkgView.frame = CGRectMake(0, kTabBarHeight, screenWidth, screenHeigth-kTabBarHeight);
        [_bkgView.iconCell.iconButton addTarget: self action:@selector(clickAvatarBtu) forControlEvents:UIControlEventTouchUpInside];
        [_bkgView.logoutBtn addTarget:self action:@selector(clickLogoutBtu) forControlEvents:UIControlEventTouchUpInside];
        _bkgView.nicknameCell.nicknameTextFiled.text = [_userDefaults objectForKey:@"nickname"];
        _bkgView.nicknameCell.nicknameTextFiled.delegate = self;
        _bkgView.nicknameCell.nicknameTextFiled.returnKeyType = UIReturnKeyDone;
    }
    return _bkgView;
}


- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
    }
    return _hud;
}



@end
