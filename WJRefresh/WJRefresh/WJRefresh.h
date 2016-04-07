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

- (void)addHeardRefreshTo:(UITableView *)tableView heardBlock:(refreshBlock)heardBlock;
- (void)endHeardRefresh;




@end
