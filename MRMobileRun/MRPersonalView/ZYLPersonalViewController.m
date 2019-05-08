//
//  ZYLPersonalViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import "ZYLPersonalViewController.h"
#import "ZYLPersonalInformationView.h"
#import "ZYLUploadAvatar.h"
#import "ZYLChangeNickname.h"
#import "ZYLPhotoSelectedVIew.h"
#import "ZYLBackBtn.h"
#import <MBProgressHUD.h>
#import <MGJRouter.h>
@interface ZYLPersonalViewController () <UITextFieldDelegate>

@property (strong, nonatomic) ZYLPersonalInformationView *personalInformationView;
@property (nonatomic,strong) MBProgressHUD *hud;
//@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSMutableDictionary *nicknameDic;
@end

@implementation ZYLPersonalViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden: YES];
//    self.title = @"个人信息";
//    ZYLBackBtn *backBtn = [[ZYLBackBtn alloc] init];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barItem =[[UIBarButtonItem alloc] initWithCustomView: backBtn];
//    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.personalInformationView];
    
    // Do any additional setup after loading the view.
}

- (void)back{
    [MGJRouter openURL:kMainVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
}

- (void)clickLogoutBtu{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
    [MGJRouter openURL:kLoginVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
}

- (void)clickAvatarBtu{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageWithData: [defaults objectForKey:@"myAvatar"]];
    ZYLPhotoSelectedVIew *selectView = [ZYLPhotoSelectedVIew selectViewWithDestinationImageView: imageView delegate:self];
    [self.view  addSubview:selectView];
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
            self.personalInformationView.nickameTextField.text = nickName.text;
            self.nicknameDic = [[NSMutableDictionary alloc]init];
            [self.nicknameDic setObject:self.personalInformationView.nickameTextField.text forKey:@"nickname"];
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
- (ZYLPersonalInformationView *)personalInformationView{
    if (!_personalInformationView) {
        _personalInformationView = [[ZYLPersonalInformationView alloc] init];
        _personalInformationView.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
        _personalInformationView.nickameTextField.delegate = self;
        _personalInformationView.nickameTextField.returnKeyType = UIReturnKeyDone;
        [_personalInformationView.backBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_personalInformationView.logoutBtu addTarget:self action:@selector(clickLogoutBtu) forControlEvents:UIControlEventTouchUpInside];
        
        [_personalInformationView.avatarBtu addTarget:self action:@selector(clickAvatarBtu) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _personalInformationView;
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
    }
    return _hud;
}



@end
