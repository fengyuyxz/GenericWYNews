//
//  ViewController.m
//  NewsProduct
//
//  Created by yanxuezhou on 2021/4/12.
//

#import "GenericWYNewsViewController.h"
#import "NPConstant.h"
NSString * const titleKey = @"title";
NSString * const classNameKey = @"className";
@interface GenericWYNewsViewController ()<UIScrollViewDelegate>
// 标题scrollerview
@property(nonatomic,weak) UIScrollView *titleScrollView;
// 内容容器scrollerview
@property(nonatomic,weak) UIScrollView *contentsScrollView;
// 当前点中的title
@property(nonatomic,weak) UIButton *currentTitleBut;

@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButs;

// 是否已经加装了所有标题
@property(nonatomic,assign) BOOL isLoadTitles;

@end

@implementation GenericWYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置标题
    self.title = @"网易新闻";
    // 添加标题滚动视图
    [self setupTitleScrollView];
    // 添加内容滚动视图
    [self setupContentsScrollView];
    //添加所有子控制器
//    [self setupAllChildViewController];
    // 添加所有标题 -> 由有什么功能界面来决定
//    [self setupTitleScrollViewChildTitle];
    // ios7后，导航控制器中scrollview顶部会额外添加statusbar和naviationbar的和的高度，不需要的话需去除;
    // 导航控制器里面有多个scrollview时，会随机给某个scrollview添加额外的高度
    if (@available(iOS 11.0, *)) {
        self.titleScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.contentsScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isLoadTitles == NO) {
        self.isLoadTitles = YES;
        [self setupTitleScrollViewChildTitle];
    }
}
#pragma mark - 标题点击事件
-(void)titleButClick:(UIButton *)but
{   //添加标题选中事件
//    self.currentTitleBut.selected = !self.currentTitleBut.selected;
//    but.selected = !but.selected;
    [self setTitleColor:but];
    // 将子vc添加到contentsScrollview中并滑动到对应位置
    NSInteger tag = but.tag;
    [self addChildViewControllerViewToContentView:tag];
    CGFloat contentsW = CGRectGetWidth(self.contentsScrollView.frame);
    CGFloat x = tag*contentsW;
    [self.contentsScrollView setContentOffset:CGPointMake(x, 0)];
    // 添加标题点击居中
    [self setupTitleButToCenter:but];
    // 设置选择标题缩放
    [self setTitleButScale:but];
    self.currentTitleBut = but;
}
#pragma mark - 设置标题颜色
-(void)setTitleColor:(UIButton *)but
{
    [self.currentTitleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}
#pragma mark -  设置选择标题缩放
-(void)setTitleButScale:(UIButton *)but{
    self.currentTitleBut.transform = CGAffineTransformIdentity;
    but.transform = CGAffineTransformMakeScale(1.25, 1.25);
}
#pragma mark - 添加标题点击居中
-(void)setupTitleButToCenter:(UIButton *)but
{
    CGFloat offsetX = but.center.x - CGRectGetWidth(self.titleScrollView.frame)*0.5;
//    NSLog(@"%f",offsetX);
    if (offsetX<0) {
        offsetX = 0;
    }
    CGFloat maxOffsetx = self.titleScrollView.contentSize.width - CGRectGetWidth(self.titleScrollView.frame);
    if (offsetX>maxOffsetx) {
        offsetX=maxOffsetx;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark - 将某个子视图添加到contentsView上
-(void)addChildViewControllerViewToContentView:(NSInteger)index
{
    UIViewController *vc = self.childViewControllers[index];
    //如果视图加载过了就直接返回
    if (vc.view.superview) {
        return;
    }
    CGFloat contentsW = CGRectGetWidth(self.contentsScrollView.frame);
    CGFloat x = index*contentsW;
    vc.view.frame = CGRectMake(x, 0,contentsW , CGRectGetHeight(self.contentsScrollView.frame));
    [self.contentsScrollView addSubview:vc.view];
}
#pragma mark - 添加所有标题
-(void)setupTitleScrollViewChildTitle
{
    NSInteger count = self.childViewControllers.count;
    CGFloat screenW = CGRectGetWidth(self.view.bounds);
    CGFloat titleButW = screenW/(screenW>320?5.0f:4.0f);
    for (NSInteger i=0; i<count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        UIButton * but = [self generateTitleBut:vc.title tag:i];
        but.frame = CGRectMake(i*titleButW, 0, titleButW, CGRectGetHeight(self.titleScrollView.frame));
        [self.titleScrollView addSubview:but];
        [but addTarget:self action:@selector(titleButClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [self titleButClick:but];
        }
        [self.titleButs addObject:but];
    }
    self.titleScrollView.contentSize = CGSizeMake(titleButW*count, 0);
    self.contentsScrollView.contentSize = CGSizeMake(count * screenW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}
#pragma mark - 生成标题button
-(UIButton *)generateTitleBut:(NSString *)title tag:(NSInteger)tag
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    but.tag = tag;
    return but;
}
#pragma mark -添加所有子控制器
-(void)setupAllChildViewController
{
    /*
    // 头条 热点 视频 社会 订阅 科技
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
     */
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
#pragma mark - 添加标题滚动视图
-(void)setupTitleScrollView
{
    //创建ScrollView;
    UIScrollView *titleScrollView = [[UIScrollView alloc]init];
    CGFloat y = self.navigationController.navigationBarHidden?NP_status_bar_h:NP_status_bar_h+44;
    
    titleScrollView.frame = CGRectMake(0, y, CGRectGetWidth(self.view.frame), 44);
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
}
#pragma mark - 添加内容滚动视图
-(void)setupContentsScrollView
{
    UIScrollView *contentsScrollView = [[UIScrollView alloc]init];
    contentsScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.titleScrollView.frame));
    [self.view addSubview:contentsScrollView];
    self.contentsScrollView = contentsScrollView;
    self.contentsScrollView.bounces = NO;
    self.contentsScrollView.pagingEnabled = YES;
    self.contentsScrollView.showsHorizontalScrollIndicator = NO;
    self.contentsScrollView.delegate = self;
}
#pragma mark - scrollView delegate
//滚动完成
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前滚到到的page
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    UIButton *but = self.titleButs[page];
    [self addChildViewControllerViewToContentView:page];
    [self titleButClick:but];
    
}
#pragma mark - scrolleview 滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 设置滑动时，标题缩放
    // 获取左边、右边的but
    //1.获取当前标题下标
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSInteger rightIndex = index+1;
    UIButton *leftBut = self.titleButs[index];
    UIButton *rightBut = nil;
    if (rightIndex<self.titleButs.count) {
        rightBut = self.titleButs[rightIndex];
    }
    CGFloat scale = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    CGFloat rScale = scale - index;
    CGFloat lScale = 1 - rScale;
    
    leftBut.transform = CGAffineTransformMakeScale(1+lScale*0.25,1+lScale*0.25);
    rightBut.transform = CGAffineTransformMakeScale(1+rScale * 0.25, 1+rScale * 0.25);
    
    // 颜色渐变
    UIColor *rightColor = [UIColor colorWithRed:rScale green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:lScale green:0 blue:0 alpha:1];
    
    [leftBut setTitleColor:leftColor forState:UIControlStateNormal];
    [rightBut setTitleColor:rightColor forState:UIControlStateNormal];
}

#pragma mark  - getter
-(NSMutableArray<UIButton *> *)titleButs{
    if (_titleButs == nil) {
        _titleButs = [[NSMutableArray alloc]init];
    }
    return _titleButs;
}
@end
