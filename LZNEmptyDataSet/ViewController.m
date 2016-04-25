//
//  ViewController.m
//  LZNEmptyDataSet
//
//  Created by linzhennan on 16/4/15.
//  Copyright © 2016年 Zhennan Lin. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+EmptyDataSet.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITableViewEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"孩子玩什么";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewEmptyDataSetDelegate
- (void)onClickScreen {
    // TODO
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cid" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld行", (long)indexPath.row];
    return cell;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cid"];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickScreen)];
        [_tableView addGestureRecognizer:tapGesture];
    }
    return _tableView;
}

@end
