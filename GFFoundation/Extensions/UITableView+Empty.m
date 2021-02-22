//
//  UITableView+Empty.m
//  NewsEarn
//
//  Created by zhubch on 2018/5/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "UITableView+Empty.h"
#import "NEFoundation.h"

@implementation UITableView (Empty)

- (void)setEmptyView:(UIView *)emptyView {
    [self.emptyView removeFromSuperview];
    emptyView.tag = 46544654;
    emptyView.hidden = YES;
    emptyView.frame = self.bounds;
    [self addSubview:emptyView];
}

- (UIView *)emptyView {
    return [self viewWithTag:46544654];
}

- (void)setLoadingView:(UIView *)loadingView {
    loadingView.tag = 46544655;
    loadingView.hidden = YES;
    loadingView.frame = self.bounds;
    [self addSubview:loadingView];
}

- (UIView *)loadingView {
    return [self viewWithTag:46544655];
}

- (BOOL)isLoading {
    return [objc_getAssociatedObject(self, "isLoading") boolValue];
}

- (void)setIsLoading:(BOOL)isLoading {
    UIActivityIndicatorView *loadingView = [self.loadingView viewWithTag:46544656];
    [loadingView removeFromSuperview];
    if (isLoading && self.loadingView) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.tag = 46544656;
        loadingView.center = self.loadingView.center;
        [loadingView startAnimating];
        [self.loadingView addSubview:loadingView];
    }

    objc_setAssociatedObject(self, "isLoading", @(isLoading), OBJC_ASSOCIATION_RETAIN);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(reloadData) withSwizzledSelector:@selector(ne_reloadData)];
    });
}

- (void)ne_reloadData {
    [self ne_reloadData];
    
    if (self.emptyView == nil) {
        return;
    }
        
    NSUInteger sections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [self.dataSource numberOfSectionsInTableView:self];
    }
    NSUInteger rows = 0;
    for (int i = 0; i < sections; i ++) {
        rows += [self.dataSource tableView:self numberOfRowsInSection:i];
    }
    self.emptyView.hidden = rows || self.isLoading;
    self.loadingView.hidden = rows || self.isLoading == NO;
}

@end


@implementation UICollectionView (Empty)

- (void)setEmptyView:(UIView *)emptyView {
    [self.emptyView removeFromSuperview];
    emptyView.tag = 46544654;
    emptyView.hidden = YES;
    emptyView.frame = self.bounds;
    [self addSubview:emptyView];
}

- (UIView *)emptyView {
    return [self viewWithTag:46544654];
}

- (void)setLoadingView:(UIView *)loadingView {
    loadingView.tag = 46544655;
    loadingView.hidden = YES;
    loadingView.frame = self.bounds;
    [self addSubview:loadingView];
}

- (UIView *)loadingView {
    return [self viewWithTag:46544655];
}

- (BOOL)isLoading {
    return [objc_getAssociatedObject(self, "isLoading") boolValue];
}

- (void)setIsLoading:(BOOL)isLoading {
    UIActivityIndicatorView *loadingView = [self.loadingView viewWithTag:46544656];
    [loadingView removeFromSuperview];
    if (isLoading && self.loadingView) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.tag = 46544656;
        loadingView.center = self.loadingView.center;
        [loadingView startAnimating];
        [self.loadingView addSubview:loadingView];
    }
    
    objc_setAssociatedObject(self, "isLoading", @(isLoading), OBJC_ASSOCIATION_RETAIN);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(reloadData) withSwizzledSelector:@selector(ne_reloadData)];
    });
}

- (void)ne_reloadData {
    [self ne_reloadData];
    
    if (self.emptyView == nil) {
        return;
    }
    
    NSUInteger sections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [self.dataSource numberOfSectionsInCollectionView:self];
    }
    NSUInteger rows = 0;
    for (int i = 0; i < sections; i ++) {
        rows += [self.dataSource collectionView:self numberOfItemsInSection:i];
    }
    self.emptyView.hidden = rows || self.isLoading;
    self.loadingView.hidden = rows || self.isLoading == NO;
}

@end
