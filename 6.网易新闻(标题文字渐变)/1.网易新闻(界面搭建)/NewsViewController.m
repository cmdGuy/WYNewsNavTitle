//
//  NewsViewController.m
//  1.网易新闻(界面搭建)
//
//  Created by 张 on 15/12/28.
//  Copyright © 2015年 张树锋. All rights reserved.
//

#import "NewsViewController.h"

#import "TopViewController.h"
#import "HotViewController.h"
#import "SocialViewController.h"
#import "VideoViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

static CGFloat const navBarH = 64;
static CGFloat const titleScrollViewH = 44;
static CGFloat const btnW = 100;
static CGFloat const titleScale = 1.3;

#define SFScreenW [UIScreen mainScreen].bounds.size.width
#define SFScreenH [UIScreen mainScreen].bounds.size.height
@interface NewsViewController ()<UIScrollViewDelegate>

/**
  头部标题
 */
@property (nonatomic,weak) UIScrollView *titleScrollView;
/**
  内容
 */
@property (nonatomic,weak) UIScrollView *contentScrollView;


/**
  选中的按钮
 */
@property (nonatomic,weak) UIButton *selectedBtn;


// 保存所有按钮的数组
@property (nonatomic, strong) NSMutableArray <UIButton *> *titlesBtns;


@end

@implementation NewsViewController

//懒加载
- (NSMutableArray<UIButton *> *)titlesBtns {
    
    if (!_titlesBtns) {
        _titlesBtns = [NSMutableArray array];
    }
    return _titlesBtns;
}
#pragma mark - 控制器view的生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加标题的scrollview
    [self setUptitleScrollView];
    //添加内容的scrollview
    [self setUpContentScrollView];
    //添加所有的子控制器
    [self setUpAllChildViewController];
    //添加标题按钮
    [self setUpAllTitleButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 初始化方法

- (void)setUptitleScrollView {
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    CGFloat titleScrollViewX = 0;
    CGFloat titleScrollViewY = self.navigationController ? navBarH : 0;
    CGFloat titleScrollerViewW = SFScreenW;
    titleScrollView.frame = CGRectMake(titleScrollViewX,titleScrollViewY,titleScrollerViewW ,titleScrollViewH);
    titleScrollView.backgroundColor = [UIColor greenColor];
    self.titleScrollView = titleScrollView;
    [self.view addSubview:titleScrollView];
}

- (void)setUpContentScrollView {
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    CGFloat contentScrollViewX = 0;
    CGFloat contentScrollViewY = CGRectGetMaxY(self.titleScrollView.frame);
    CGFloat contentScrollViewW = SFScreenW;
    CGFloat contentScrollerH =SFScreenH - contentScrollViewY;
    contentScrollView.frame = CGRectMake(contentScrollViewX, contentScrollViewY, contentScrollViewW, contentScrollerH);
    contentScrollView.backgroundColor = [UIColor blueColor];
    self.contentScrollView = contentScrollView;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
}

- (void)setUpAllChildViewController {
    TopViewController *topVc = [[TopViewController alloc] init];
    topVc.title = @"头条";
    [self addChildViewController:topVc];
    
    HotViewController *hotVc = [[HotViewController alloc] init];
    hotVc.title = @"热点";
    [self addChildViewController:hotVc];
    
    SocialViewController *socialVc = [[SocialViewController alloc] init];
    socialVc.title = @"社会";
    [self addChildViewController:socialVc];
    
    VideoViewController *videoVc = [[VideoViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    ReaderViewController *readerVc = [[ReaderViewController alloc] init];
    readerVc.title = @"订阅";
    [self addChildViewController:readerVc];
    
    ScienceViewController *scienceVc = [[ScienceViewController alloc] init];
    scienceVc.title = @"科学";
    [self addChildViewController:scienceVc];
}

- (void)setUpAllTitleButton {
    CGFloat btnCount = self.childViewControllers.count;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnH = titleScrollViewH;
    
    for (NSInteger i = 0; i < btnCount; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.tag = i;
        btnX = i * btnW;
        titleBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [self.titleScrollView addSubview:titleBtn];
        UIViewController *vc = self.childViewControllers[i];
        [titleBtn setTitle:vc.title forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (i == 0) {
            [self titleBtnClick:titleBtn];
        }
        [self.titlesBtns addObject:titleBtn];
    }
    //标题滚动范围
    CGFloat contentW = btnW * btnCount;
    self.titleScrollView.contentSize = CGSizeMake(contentW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    //内容滚动范围
    self.contentScrollView.contentSize = CGSizeMake(btnCount * SFScreenW, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
}

- (void)titleBtnClick:(UIButton *)button {
    
    NSInteger i = button.tag;
    
    [self didSelectBtn:button];
    [self setupChildViewController:i];
    CGFloat x = i * SFScreenW;
    CGFloat y = 0;
    CGFloat w = SFScreenW;
    CGFloat h = self.contentScrollView.frame.size.height;
    
    UIViewController *vc = self.childViewControllers[i];
    vc.view.frame = CGRectMake(x, y, w, h);
    [self.contentScrollView addSubview:vc.view];
    
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

- (void)didSelectBtn:(UIButton *)btn {
    
    [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.selectedBtn = btn;
    
    [self setUpTitleBtnCenter:btn];
    
}

- (void)setupChildViewController:(NSInteger)i
{
    // 取出对应子控制器
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) return;
    
    CGFloat x = i * SFScreenW;
    CGFloat y = 0;
    CGFloat w = SFScreenW;
    CGFloat h = self.contentScrollView.bounds.size.height;
    vc.view.frame = CGRectMake(x, y, w, h);
    [self.contentScrollView addSubview:vc.view];
    
}

//让标题按钮居中

- (void)setUpTitleBtnCenter:(UIButton *)btn {
    
    CGFloat offsetX = btn.center.x - SFScreenW * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - SFScreenW;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake (offsetX, 0) animated:YES];
}

// 6.滚动完成的时候做事情
#pragma mark - UIScrollViewDelegate
// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 0.当前偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 1.当前页码
    NSInteger i = offsetX / SFScreenW;
    
    // 2.获取选中的按钮
    UIButton *btn = self.titlesBtns[i];
    
    // 3.选中对应标题按钮
    [self didSelectBtn:btn];
    
    // 4.把对应的子控制器的view添加上去,显示出来
    [self setupChildViewController:i];
    
}

#pragma mark - 标题文字的缩放

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger count = self.titlesBtns.count;
    //按钮的下标
    NSInteger leftI = scrollView.contentOffset.x / SFScreenW;
    NSInteger rightI = leftI + 1;
    
    UIButton *leftBtn = self.titlesBtns[leftI];
    
    UIButton *rightBtn;
    if (rightI < count) {
        rightBtn = self.titlesBtns[rightI];
    }
    
    CGFloat scaleR = scrollView.contentOffset.x / SFScreenW - leftI;
    
    CGFloat scaleL = 1 - scaleR;
    
    CGFloat transformScale = titleScale - 1;
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * transformScale + 1, scaleL * transformScale + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * transformScale + 1, scaleR * transformScale + 1);
    
    // 4.标题颜色渐变
    // 4.1获取右边按钮颜色
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
}


@end
