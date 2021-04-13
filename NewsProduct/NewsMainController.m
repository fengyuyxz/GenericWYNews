//
//  NewsMainController.m
//  NewsProduct
//
//  Created by yanxuezhou on 2021/4/13.
//

#import "NewsMainController.h"

@interface NewsMainController ()

@end

@implementation NewsMainController

- (void)viewDidLoad {
    [self setupAllChildViewController];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setupAllChildViewController{
    NSArray<NSDictionary<NSString *,NSString *> *> *childVCName = @[
    @{titleKey:@"头条",classNameKey:@"TopLineController"},
    @{titleKey:@"热点",classNameKey:@"HotLineController"},
    @{titleKey:@"视频",classNameKey:@"NPViedoController"},
    @{titleKey:@"社会",classNameKey:@"NPSocialController"},
    @{titleKey:@"订阅",classNameKey:@"NPSubscribeController"},
    @{titleKey:@"科技",classNameKey:@"NPScienceController"}];
    for (NSDictionary<NSString *,NSString *> * dic in childVCName) {
        NSString *vcName = dic[classNameKey];
        NSString *title = dic[titleKey];
        UIViewController *vc = [self generateControllerWithName:vcName title:title];
        if (vc) {
            [self addChildViewController:vc];
        }
    }
}
#pragma mark - 通过类名生成vc对象
-(UIViewController *)generateControllerWithName:(NSString *)vcName title:(NSString *)title;
{
    Class vcClazz = NSClassFromString(vcName);
    if (vcClazz) {
        UIViewController *vc = [[vcClazz alloc]init];
        if (vc) {
            vc.title = title;
        }
        return vc;
    }
    return nil;
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
