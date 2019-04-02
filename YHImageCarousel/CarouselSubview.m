//
//  CarouselSubview.m
//  YHImageCarousel
//
//  Created by zyh on 2016/12/8.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import "CarouselSubview.h"

@interface CarouselSubview ()
@property (nonatomic, assign) CGFloat spacingWidth;
@end

@implementation CarouselSubview

- (instancetype)initWithFrame:(CGRect)frame spacingWidth:(CGFloat)spacingWidth{
    self = [super initWithFrame:frame];
    if (self) {
        _spacingWidth = spacingWidth;
        [self addSubview:self.containerView];
    }
    return self;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - _spacingWidth, self.bounds.size.height)];
        
        _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _containerView.layer.shadowOffset = CGSizeMake(1,2);
        _containerView.layer.shadowOpacity = 0.2;
        _containerView.layer.shadowRadius = 2;
    }
    return _containerView;
}

@end

@implementation CarouselCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLbl];
    }
    return self;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.cornerRadius = 5;
        _imageView.layer.masksToBounds = YES;
        _backLineImageView = [[UIImageView alloc] init];
        _backLineImageView.backgroundColor = [UIColor lightGrayColor];
        _backLineImageView.alpha = 0.75;
        _backLineImageView.frame = CGRectMake(0, self.bounds.size.height-28, self.bounds.size.width, 28);
        [_imageView addSubview:_backLineImageView];
    }
    return _imageView;
}

- (UILabel *)titleLbl {
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bounds.size.height-28, self.bounds.size.width-20, 20)];
        _titleLbl.font = [UIFont systemFontOfSize:13];
        _titleLbl.textColor = [UIColor whiteColor];
    }
    return _titleLbl;
}
@end
