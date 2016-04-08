# WJRefresh
a easy refresh for tableView


    // 创建refresh
    _refresh = [[WJRefresh alloc]init];
    __weak typeof(self)weakSelf = self;
    [_refresh addHeardRefreshTo:tableView heardBlock:^{
        [weakSelf createData];    // 获取数据
    } footBlok:^{
        [weakSelf createFootData];// 加载更多数据
    }];
    [_refresh beginHeardRefresh]; // 开始刷新
    
    // 结束刷新
    [_refresh endRefresh];
    
    
