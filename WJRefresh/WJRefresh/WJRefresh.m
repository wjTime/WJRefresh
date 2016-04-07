//
//  WJRefresh.m
//  WJRefresh
//
//  Created by 吴计强 on 16/4/6.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//

#define WJRefreshDropHeight 40
#import "WJRefresh.h"


@interface WJRefresh ()<UITableViewDelegate>

@property (nonatomic,weak)UITableView *RefreshTableView;
@property (nonatomic,copy)refreshBlock heardRefresh;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIActivityIndicatorView *refreshLoadingView;


@property (nonatomic,assign)BOOL isRefreshing;

@end

@implementation WJRefresh

- (void)addHeardRefreshTo:(UITableView *)tableView heardBlock:(refreshBlock)heardBlock{
    __weak typeof(self)weakSelf = self;
    [tableView addSubview:weakSelf];
    CGRect frame = tableView.frame;
    frame.origin.x = 0;
    frame.origin.y = - WJRefreshDropHeight;
    frame.size.height = WJRefreshDropHeight;
    
    weakSelf.frame = frame;
    weakSelf.RefreshTableView = tableView;
    weakSelf.heardRefresh = heardBlock;
   [tableView addObserver:weakSelf forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    CGPoint offSetPoint = [[change valueForKey:@"new"] CGPointValue];
    self.arrowImageView.alpha = 1.0;
    if (offSetPoint.y <= -WJRefreshDropHeight && (!self.isRefreshing)) {
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.alpha = 0.0;
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.arrowImageView.hidden = YES;
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        }];
        [self.refreshLoadingView startAnimating];
        self.isRefreshing = YES;
        self.RefreshTableView.contentInset = UIEdgeInsetsMake(WJRefreshDropHeight, 0, 0, 0);
        __weak typeof(self)weakSelf = self;
        if (weakSelf.heardRefresh) {
            weakSelf.heardRefresh();
        }
    }
    if (offSetPoint.y == 0.0) {
        
        [self.refreshLoadingView stopAnimating];
        self.isRefreshing = NO;
    }
}

- (void)endHeardRefresh{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.RefreshTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        weakSelf.arrowImageView.alpha = 1;
        weakSelf.arrowImageView.hidden = NO;
    }];
    
}


- (UIActivityIndicatorView *)refreshLoadingView{
    if (_refreshLoadingView == nil) {
        _refreshLoadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 0, WJRefreshDropHeight, WJRefreshDropHeight)];
        _refreshLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:_refreshLoadingView];
    }
    return _refreshLoadingView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 15, 40)];
        _arrowImageView.image = [UIImage imageNamed:@"WJRefreshArrow"];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (void)dealloc{
    NSLog(@"dealloc");
    [self.RefreshTableView removeObserver:self forKeyPath:@"contentOffset"];
}



@end
