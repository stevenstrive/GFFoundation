//
//  UITableView+Empty.h
//  NewsEarn
//
//  Created by zhubch on 2018/5/28.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(Empty)

@property (nonatomic,strong) UIView *emptyView;
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,assign) BOOL isLoading;

@end

@interface UICollectionView(Empty)

@property (nonatomic,strong) UIView *emptyView;
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,assign) BOOL isLoading;

@end
