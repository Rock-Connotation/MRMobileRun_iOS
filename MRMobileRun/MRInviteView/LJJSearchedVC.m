//
//  LJJSearchedVC.m
//  MRMobileRun
//
//  Created by J J on 2019/7/31.
//

#import "LJJSearchedVC.h"
#import "LJJSearchedView.h"
@interface LJJSearchedVC ()
@property (strong, nonatomic) LJJSearchedView *searchedView;
@end

@implementation LJJSearchedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchedView.labelInvite = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth *340.0/750, screenHeigth * 59.0/1334, screenWidth * 73.0/750, screenHeigth *50.0/1334)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
