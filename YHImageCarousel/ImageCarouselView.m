//
//  ImageCarouselView.m
//  YHImageCarousel
//
//  Created by zyh on 2016/12/8.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import "ImageCarouselView.h"
//#import "SDWebImage/UIImageView+WebCache.h"

@interface ImageCarouselView ()<UIScrollViewDelegate>

/**
 内部scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 每页的大小
 */
@property (nonatomic, assign) CGSize pageSize;

/**
 存放containerView的数组
 */
@property (nonatomic, strong) NSMutableArray *containerViews;
/**
 当前显示页的index
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 轮播图片总页数
 */
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation ImageCarouselView

#pragma mark - Override Methods

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<ImageCarouselViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self)
    {
        _delegate = delegate;
        self.clipsToBounds = YES;
        self.containerViews = [NSMutableArray array];
    }
    return self;
}

- (void)setupUI {
    self.pageCount = self.posterInfoArr.count;
    self.pageSize = [self sizeForPageInCarouselView];
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
    }
    // 重置_scrollView的contentSize
    self.scrollView.frame = CGRectMake(self.spacingWidth*2, 0, self.pageSize.width, self.pageSize.height);
    self.scrollView.contentSize = CGSizeMake(self.pageSize.width * self.pageCount, 0);
    
    // 创建CarouselSubview容器
    // 先清空再创建
    for (CarouselSubview *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
    [self.containerViews removeAllObjects];
    for (NSInteger i = 0; i < self.pageCount; i++) {
        CarouselSubview *containerView = [[CarouselSubview alloc] initWithFrame:CGRectMake(i * self.pageSize.width, 0, self.pageSize.width, self.pageSize.height) spacingWidth:self.spacingWidth];
        [containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)]];
        containerView.tag = i + 10;
        [self.containerViews addObject:containerView];
        [self.scrollView addSubview:containerView];
        // 添加containerView中的子控件
        CarouselCell *cell = [self carouselViewCellAtIndex:i];
        cell.frame = containerView.bounds;
        [containerView.containerView addSubview:cell];
        
    }
    // 滚动到中间的containerView
    self.currentPageIndex = (self.pageCount/2);
    self.scrollView.contentOffset = CGPointMake(self.pageSize.width * self.currentPageIndex, 0);
}

//点击了cell
- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectPageAtIndex:)]) {
        NSInteger tag = gesture.view.tag;
        [self.delegate carouselView:self didSelectPageAtIndex:tag-10];
    }
}

-(void)timerStart
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoNextPage) object:nil];
    if (self.pageCount>2) {
        [self performSelector:@selector(autoNextPage) withObject:nil afterDelay:self.timeInterval];
    }
}

-(void)timerStop
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoNextPage) object:nil];
}

-(void)autoNextPage{//定时自动滚动_ScrollView
    [self.scrollView setContentOffset:CGPointMake((int)(self.pageCount/2+1) * self.pageSize.width, 0) animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        if (self.pageCount == 0) {
            return;
        }
        
        // 向手指向右滑动一个单位,需要删除最后的一个cell，前面添加一个cell
        if (self.scrollView.contentOffset.x <= self.pageSize.width * (int)(self.pageCount/2-1)) {
            // 删除显示组里最后一个cell
            CarouselSubview *lastContainerView = (CarouselSubview *)self.containerViews.lastObject;
            [self.containerViews removeLastObject];
            [self.containerViews insertObject:lastContainerView atIndex:0];
            [self makeCarouselSubviewFrame];
        }
        
        // 手指向左滑动一个单位，需要删除最前面的一个cell，最后添加一个cell
        if ((int)self.scrollView.contentOffset.x >= (int)(self.pageSize.width * (int)(self.pageCount/2+1))) {
            // 删除第一个cell
            CarouselSubview *firstContainerView = (CarouselSubview *)self.containerViews[0];
            [self.containerViews removeObjectAtIndex:0];
            [self.containerViews addObject:firstContainerView];
            [self makeCarouselSubviewFrame];
        }
        
        CarouselSubview *nowContainerView = self.containerViews[(int)(self.pageCount/2)];
        self.currentPageIndex = nowContainerView.tag-10;
        if ([self.delegate respondsToSelector:@selector(carouselView:didScrollToPage:)]) {
            [self.delegate carouselView:self didScrollToPage:self.currentPageIndex];
        }
    }
}

- (void)makeCarouselSubviewFrame{
    // 将剩下的cell都向左移动一个cell宽度的位置
    for (NSInteger i = 0; i < self.containerViews.count; i++) {
        CarouselSubview *containerView = self.containerViews[i];
        containerView.frame = CGRectMake(i * self.pageSize.width, 0, containerView.frame.size.width, containerView.frame.size.height);
    }
    // 重新至中
    self.scrollView.contentOffset = CGPointMake(self.pageSize.width * (int)(self.pageCount/2), 0);
}

- (CarouselCell *)carouselViewCellAtIndex:(NSUInteger)index {
    CarouselCell *cell = [[CarouselCell alloc] initWithFrame:CGRectMake(0, 0, self.pageSize.width-self.spacingWidth, self.pageSize.height)];
    [cell.imageView setImage:[UIImage imageNamed:self.posterInfoArr[index]]];
    cell.backLineImageView.hidden = NO;
    cell.titleLbl.text = [NSString stringWithFormat:@"第%lu页",(unsigned long)index];
    return cell;
}

-(void)reloadView:(NSArray *)posterInfoArr{
    int mid = (int)(posterInfoArr.count/2);
    if (posterInfoArr.count%2==1) {
        //奇数时候排序（例：01234->34012）
        NSArray * arr1 = [posterInfoArr subarrayWithRange:NSMakeRange(mid+1, posterInfoArr.count-(mid+1))];
        NSArray * arr2 = [posterInfoArr subarrayWithRange:NSMakeRange(0, posterInfoArr.count-mid)];
        NSMutableArray *infoArr = [[NSMutableArray alloc] init];
        [infoArr addObjectsFromArray:arr1];
        [infoArr addObjectsFromArray:arr2];
        self.posterInfoArr = infoArr;
    }else{
        //偶数时候排序（例：0123->2301）
        NSArray * arr1 = [posterInfoArr subarrayWithRange:NSMakeRange(mid, posterInfoArr.count-mid)];
        NSArray * arr2 = [posterInfoArr subarrayWithRange:NSMakeRange(0, posterInfoArr.count-mid)];
        NSMutableArray *infoArr = [[NSMutableArray alloc] init];
        [infoArr addObjectsFromArray:arr1];
        [infoArr addObjectsFromArray:arr2];
        self.posterInfoArr = infoArr;
    }
    
    [self setupUI];
}

- (CGSize)sizeForPageInCarouselView{
    return CGSizeMake(self.carouselViewWidth+self.spacingWidth, self.bounds.size.height-5);
}
@end
