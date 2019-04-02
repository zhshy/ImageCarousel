//
//  CarouselSubview.h
//  YHImageCarousel
//
//  Created by zyh on 2016/12/8.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselSubview : UIView
- (instancetype)initWithFrame:(CGRect)frame spacingWidth:(CGFloat)spacingWidth;
/**
 *  容器视图
 */
@property (nonatomic, strong) UIView *containerView;

@end

// cell基类
@interface CarouselCell : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *backLineImageView;
@end
