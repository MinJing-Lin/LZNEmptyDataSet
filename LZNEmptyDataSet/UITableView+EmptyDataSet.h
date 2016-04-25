//
//  UITableView+EmptyDataSet.h
//  LZNEmptyDataSet
//
//  Created by linzhennan on 16/4/18.
//  Copyright © 2016年 Zhennan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewEmptyDataSetDelegate <NSObject>

- (void)onClickScreen;

@end

@interface UITableView (EmptyDataSet)

@end
