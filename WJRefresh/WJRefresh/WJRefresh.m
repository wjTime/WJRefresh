//
//  WJRefresh.m
//  WJRefresh
//
//  Created by 吴计强 on 16/4/6.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//

#define WJRefreshDropHeight  40
#define WJRefreshScreenW     [UIScreen mainScreen].bounds.size.width
#import "WJRefresh.h"


@interface WJRefresh ()<UITableViewDelegate>

@property (nonatomic,weak)   UITableView *RefreshTableView;
@property (nonatomic,copy)   refreshBlock heardRefresh;
@property (nonatomic,copy)   refreshBlock footRefresh;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UIActivityIndicatorView *refreshLoadingView;
@property (nonatomic,strong) UILabel *tipLb;

@property (nonatomic,assign) BOOL isHeard;
@property (nonatomic,assign) BOOL isRefreshing;

@property (nonatomic,assign) BOOL isFootFreshing;

@end

@implementation WJRefresh

- (void)addHeardRefreshTo:(UITableView *)tableView heardBlock:(refreshBlock)heardBlock footBlok:(refreshBlock)footBlock{
    [tableView addSubview:self];
    self.RefreshTableView = tableView;
    self.heardRefresh = heardBlock;
    self.footRefresh = footBlock;
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

// 切换头尾刷新控件
- (void)changeFrameWithoffY:(CGFloat)offY{
    if (offY <= 0 && !self.isHeard && !self.isFootFreshing) {
        self.tipLb.text = @"下拉刷新";
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.isHeard = YES;
        CGRect frame = self.RefreshTableView.frame;
        frame.origin.x = 0;
        frame.origin.y = - WJRefreshDropHeight;
        frame.size.height = WJRefreshDropHeight;
        self.frame = frame;
    }
    if (offY > 0 && self.isHeard && !self.isRefreshing) {
        self.isHeard = NO;
        self.tipLb.text = @"上拉加载更多";
        self.frame = CGRectMake(0, self.RefreshTableView.contentSize.height,
                                self.frame.size.width, WJRefreshDropHeight);
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGPoint offSetPoint = [[change valueForKey:@"new"] CGPointValue];
    [self changeFrameWithoffY:offSetPoint.y];
    self.arrowImageView.alpha = 1.0;
    if (offSetPoint.y <= -WJRefreshDropHeight && (!self.isRefreshing) && !self.isFootFreshing) {
        self.isRefreshing = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.arrowImageView.hidden = YES;
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
             [self.refreshLoadingView startAnimating];
        }];
        self.RefreshTableView.contentInset = UIEdgeInsetsMake(WJRefreshDropHeight, 0, 0, 0);
 
        if (self.heardRefresh) {
            NSLog(@"调用头部刷新block");
            self.heardRefresh();
        }
    }
    if (offSetPoint.y == 0.0) {
        [self.refreshLoadingView stopAnimating];
        self.isRefreshing = NO;
    }
    
    
    if (offSetPoint.y + self.RefreshTableView.frame.size.height  >= self.RefreshTableView.contentSize.height +WJRefreshDropHeight && !self.isFootFreshing && self.RefreshTableView.contentSize.height > self.RefreshTableView.frame.size.height && !self.isRefreshing) {
        self.arrowImageView.hidden = NO;
        self.isFootFreshing = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        } completion:^(BOOL finished) {
            self.arrowImageView.hidden = YES;
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            [self.refreshLoadingView startAnimating];
        }];
        self.RefreshTableView.contentInset = UIEdgeInsetsMake(0, 0, WJRefreshDropHeight, 0);
        if (self.footRefresh) {
            NSLog(@"尾部加载更多block");
            self.footRefresh();
        }
    }
    
    
}

- (void)beginHeardRefresh{
    [UIView animateWithDuration:0.25 animations:^{
        self.RefreshTableView.contentOffset = CGPointMake(0, -WJRefreshDropHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)endRefresh{
    [self.refreshLoadingView stopAnimating];
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isFootFreshing) {
                self.frame = CGRectMake(0, self.RefreshTableView.contentSize.height,self.frame.size.width, WJRefreshDropHeight);
            }
            self.RefreshTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.isFootFreshing = NO;
            self.isRefreshing   = NO;
        }completion:^(BOOL finished) {
            self.arrowImageView.hidden = NO;
        }];
}

- (void)endFootRefresh{
    
}

- (UIActivityIndicatorView *)refreshLoadingView{
    if (_refreshLoadingView == nil) {
        CGPoint point = CGPointMake(self.arrowImageView.frame.size.width/2 + self.arrowImageView.frame.origin.x, self.arrowImageView.frame.size.height/2 + self.arrowImageView.frame.origin.y);
        _refreshLoadingView = [[UIActivityIndicatorView alloc]init];
        CGSize size = CGSizeMake(WJRefreshDropHeight, WJRefreshDropHeight);
        _refreshLoadingView.frame = CGRectMake(point.x - size.width/2, point.y - size.height/2, size.width, size.height);
        _refreshLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:_refreshLoadingView];
    }
    return _refreshLoadingView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WJRefreshScreenW/3, 0, 15, WJRefreshDropHeight)];
        _arrowImageView.image = [UIImage imageNamed:@"WJRefreshArrow"];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UILabel *)tipLb{
    if (_tipLb == nil) {
        _tipLb = [[UILabel alloc]initWithFrame:CGRectMake((WJRefreshScreenW-100)/2, 5, 100, 15)];
        _tipLb.textAlignment = NSTextAlignmentCenter;
        _tipLb.textColor = [UIColor grayColor];
        _tipLb.font = [UIFont systemFontOfSize:12];
        //_tipLb.backgroundColor = [UIColor blueColor];
        [self addSubview:_tipLb];
    }
    return _tipLb;
}

- (void)dealloc{
    NSLog(@"WJRefresh dealloc");
    [self.RefreshTableView removeObserver:self forKeyPath:@"contentOffset"];
}



@end
