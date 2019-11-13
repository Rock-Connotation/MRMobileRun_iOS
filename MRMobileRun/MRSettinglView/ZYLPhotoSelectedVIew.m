//
//  ZYLPhotoSelectedVIew.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import "ZYLPhotoSelectedVIew.h"
#import "WeKit.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Masonry.h>

static const NSInteger alertColor = 0xef6253;
static const NSInteger normalColor = 0x1A165B;

@interface ZYLPhotoSelectedVIew ()
@property UIImageView *selectWindowImageView;
@property UIImageView *horizonalLine;
@property UIButton *selectButton;
@property UIButton *takePhotoButton;
@property UIView *effectView;
@property UIButton *cancelButton;
@property CGFloat rateX;
@property CGFloat rateY;
@property UIImageView *destinationImageView;
@property UIViewController *delegate;
@end


@implementation ZYLPhotoSelectedVIew


- (instancetype)initWithDestinationImageView:(UIImageView *)imageView delegate:(UIViewController  *) delegate {
    self = [self initWithFrame:ScreenFrame];
    if (self) {
        self.rateX = ScreenWidth / 375;
        self.rateY = ScreenHeight / 667;
        self.destinationImageView = imageView;
        self.delegate = delegate;
        
        [self initEffectView];
        [self initAlertView];
    }
    
    
    
    return self;
    
}

- (void)getCameraAndAlbumPrivicy{
    PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    printf("%s",photoStatus);
    
    AVAuthorizationStatus avStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    printf("%s",avStatus);
}

- (void)initEffectView {
    self.effectView = [[UIView alloc] initWithFrame:ScreenFrame];
    self.effectView.backgroundColor = [UIColor colorWithRed:114.0/255 green:109.0/255 blue:131.0/255 alpha:0.62];
    self.effectView.userInteractionEnabled = YES;
    [self.effectView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEffectView)]];
    [self addSubview:self.effectView];
}

- (void)initAlertView {
    UIImage *i1 = [UIImage imageNamed:@"换头像弹窗"];
    self.selectWindowImageView = [[UIImageView alloc] initWithImage:i1];
    self.selectWindowImageView.userInteractionEnabled = YES;
    [self addSubview:self.selectWindowImageView];
    
    self.selectButton = [[UIButton alloc] init];
    [self.selectButton setTitle:@"从相册中选择" forState:UIControlStateNormal];
    [self.selectButton setTitleColor:UIColorFromRGB(normalColor) forState:UIControlStateNormal];
    self.selectButton.tag = 0;
    [self.selectButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectWindowImageView addSubview:self.selectButton];
    
    self.takePhotoButton = [[UIButton alloc] init];
    [self.takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
    [self.takePhotoButton setTitleColor:UIColorFromRGB(normalColor) forState:UIControlStateNormal];
    self.takePhotoButton.tag = 1;
    [self.takePhotoButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectWindowImageView addSubview:self.takePhotoButton];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:UIColorFromRGB(alertColor) forState:UIControlStateNormal];
    self.cancelButton.tag = 2;
    [self.cancelButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectWindowImageView addSubview:self.cancelButton];
    
    UIImage *i2 = [UIImage imageNamed:@"horizonal_line"];
    self.horizonalLine = [[UIImageView alloc] initWithImage:i2];
    [self.selectWindowImageView addSubview:self.horizonalLine];
}

- (void)click:(id)button {
    
    UIButton *theButton = button;
    if (theButton.tag == 0) {
        //从相册中选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            NSLog(@"1");
            [self takePhoto:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            NSLog(@"2");
            [self takePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
        } else {
            NSLog(@"从相册中选择时，不知哪里出错了");
        }
    } else if (theButton.tag == 1) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self takePhoto:UIImagePickerControllerSourceTypeCamera];
        } else {
            NSLog(@"拍照时，不知哪里出错了");
        }
    } else if (theButton.tag == 2) {
        //取消
    }
    self.hidden = YES;
    
}

- (void)takePhoto:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //TODO 没用？
    //    imagePickerController.navigationBar.backgroundColor = SD_MAIN_COLOR;
    //    imagePickerController.navigationBar.alpha = 1;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = type;
    [self.delegate presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.destinationImageView.image = info[UIImagePickerControllerEditedImage];
    
    self.destinationImageView.layer.masksToBounds=YES;
    
    NSLog(@"\n\n\n123");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAvatar" object:nil];
}

- (void)updateConstraints {
    
    
    
    
    [self.selectWindowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(216*self.rateY); //with is an optional semantic filler
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(306*self.rateX));
        make.height.equalTo(@(163.5*self.rateY));
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectWindowImageView.mas_top).with.offset(54.5*0*self.rateY); //with is an optional semantic filler
        make.left.equalTo(self.selectWindowImageView.mas_left);
        make.width.equalTo(@(306*self.rateX));
        make.height.equalTo(@(54*self.rateX));
    }];
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectWindowImageView.mas_top).with.offset(54.5*1*self.rateY); //with is an optional semantic filler
        make.left.equalTo(self.selectWindowImageView.mas_left);
        make.width.equalTo(@(306*self.rateX));
        make.height.equalTo(@(54*self.rateX));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectWindowImageView.mas_top).with.offset(54.5*2*self.rateY); //with is an optional semantic filler
        make.left.equalTo(self.selectWindowImageView.mas_left);
        make.width.equalTo(@(306*self.rateX));
        make.height.equalTo(@(54*self.rateX));
    }];
    [self.horizonalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectWindowImageView.mas_top).with.offset(54.5*2*self.rateY); //with is an optional semantic filler
        make.left.equalTo(self.selectWindowImageView.mas_left);
        make.width.equalTo(@(306*self.rateX));
        make.height.equalTo(@1);
    }];
    [super updateConstraints];
}

+ (instancetype)selectViewWithDestinationImageView:(UIImageView *)imageView delegate:(UIViewController *)delegate{
    ZYLPhotoSelectedVIew *view = [[ZYLPhotoSelectedVIew alloc] initWithDestinationImageView:imageView delegate:delegate];
    return view;
}

- (void)clickEffectView {
    self.hidden = YES;
    
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
