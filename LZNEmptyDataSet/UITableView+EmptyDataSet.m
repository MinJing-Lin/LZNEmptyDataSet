//
//  UITableView+EmptyDataSet.m
//  LZNEmptyDataSet
//
//  Created by linzhennan on 16/4/18.
//  Copyright © 2016年 Zhennan Lin. All rights reserved.
//

#import "UITableView+EmptyDataSet.h"
#import <objc/runtime.h>

@interface UITableView (EmptyDataSetPrivate)

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation UITableView (EmptyDataSet)

#pragma mark - init
+ (void)load {
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^ {
        Class class = [self class];
        
        SEL originalSelector = @selector(reloadData);
        SEL swizzledSelector = @selector(swizzled_reloadData);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_addMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - swizzled
- (void)swizzled_reloadData {
    [self swizzled_reloadData];
    
    // 判断是否有数据
    if ([self numberOfRowsInSection:0]) { // 有数据
        // 移除imgView和textLabel
        if ([self.imgView respondsToSelector:@selector(removeFromSuperview)]) {
            [self.imgView removeFromSuperview];
        }
        if ([self.textLabel respondsToSelector:@selector(removeFromSuperview)]) {
            [self.textLabel removeFromSuperview];
        }
        // 能滚动（即能上拉刷新、下拉加载）
        self.scrollEnabled = YES;
        // 如果实现了响应事件，移除它
        if ([self respondsToSelector:@selector(onClickScreen)]) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickScreen)];
            [self removeGestureRecognizer:tapGesture];
        }
    } else { // 没有数据
        // 添加imgView和textLabel
        [self addSubview:self.imgView];
        [self addSubview:self.textLabel];
        // 不能滚动（即不能上拉刷新、下拉加载）
        self.scrollEnabled = NO;
        // 如果实现了响应事件，添加它
        if ([self respondsToSelector:@selector(onClickScreen)]) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickScreen)];
            [self addGestureRecognizer:tapGesture];
        }
    }
}

#pragma mark - setters
- (void)setImgView:(UIImageView *)imgView {
    objc_setAssociatedObject(self, @selector(imgView), imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTextLabel:(UILabel *)textLabel {
    objc_setAssociatedObject(self, @selector(textLabel), textLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getters
- (UIImageView *)imgView {
    UIImageView *img = objc_getAssociatedObject(self, @selector(imgView));
    if (!img) {
        img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/3.0, ScreenWidth/3.0+40, ScreenWidth/3.0, ScreenWidth/3.0)];
        img.image = [UIImage imageNamed:@"img_default_pinwheel"];
        objc_setAssociatedObject(self, @selector(imgView), img, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @selector(imgView));
}

- (UILabel *)textLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(textLabel));
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.bounds)+40, ScreenWidth, 40)];
        label.center = CGPointMake(ScreenWidth/2.0, self.imgView.frame.origin.y+self.imgView.frame.size.height+40+20);
        label.text = @"网络不给力，点击屏幕重试";
        label.textColor = UIColorFromRGB(0x959595);
        label.textAlignment = NSTextAlignmentCenter;
        objc_setAssociatedObject(self, @selector(textLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @selector(textLabel));
}

@end

