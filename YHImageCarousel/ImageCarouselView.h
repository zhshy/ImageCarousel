//
//  ImageCarouselView.h
//  YHImageCarousel
//
//  Created by zyh on 2016/12/8.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselSubview.h"

@protocol ImageCarouselViewDelegate;

@interface ImageCarouselView : UIView

/**
 轮显图数据
 */
@property (nonatomic, strong) NSArray *posterInfoArr;
@property (nonatomic, assign) id <ImageCarouselViewDelegate>   delegate;

@property (nonatomic, assign) NSInteger timeInterval;//轮播时间
@property (nonatomic, assign) float spacingWidth;//间距
@property (nonatomic, assign) float carouselViewWidth;//正中显示的图片宽度
@property (nonatomic, strong) NSString *placeHolderName;//缓存图

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<ImageCarouselViewDelegate>)delegate;

/**
 *  海报开始滚动，view appear时启动
 */
-(void)timerStart;
/**
 *  海报停止滚动，view disappear时停止
 */
-(void)timerStop;
/**
 *  海报加载数据
 *  @param posterInfoArr 加载的数据数组
 */
-(void)reloadView:(NSArray *)posterInfoArr;
@end


@protocol  ImageCarouselViewDelegate <NSObject>

/**
 *  海报滚动
 *  @param pageNumber 滚动到的页数
 */
- (void)carouselView:(ImageCarouselView *)carouselView didScrollToPage:(NSInteger)pageNumber;

/**
 *  海报点击
 *  @param index 点击的页数
 */
- (void)carouselView:(ImageCarouselView *)carouselView didSelectPageAtIndex:(NSInteger)index;

@end

