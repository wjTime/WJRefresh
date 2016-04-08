//
//  WJRefresh.h
//  WJRefresh
//
//  Created by 吴计强 on 16/4/6.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//
typedef void(^refreshBlock)();
#import <UIKit/UIKit.h>

@interface WJRefresh : UIView

/** 添加WJRefresh控件到tableview上面 */
- (void)addHeardRefreshTo:(UITableView *)tableView heardBlock:(refreshBlock)heardBlock footBlok:(refreshBlock)footBlock;

/** 开始头部刷新 */
- (void)beginHeardRefresh;

/** 结束头部刷新 */
- (void)endRefresh;



@end
