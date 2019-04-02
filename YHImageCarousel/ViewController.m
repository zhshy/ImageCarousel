//
//  ViewController.m
//  YHImageCarousel
//
//  Created by zyh on 2016/12/8.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import "ViewController.h"
#import "ImageCarouselView.h"

//item基础间距
#define Item_Margin (9.0*self.view.bounds.size.width/375.0)
@interface ViewController () <ImageCarouselViewDelegate>

@property (nonatomic, strong) NSArray *cellInfoArray;
@property (nonatomic, strong) ImageCarouselView *imageCarouselView;
@property (nonatomic, assign)CGFloat imageHeight;//海报图片高度
@property (nonatomic, assign)CGFloat imageWidth;//海报图片宽度
@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellInfoArray =@[@"angryBirds_00.jpg",@"angryBirds_01.jpg",@"angryBirds_02.jpg",@"angryBirds_03.jpg",@"angryBirds_04.jpg"];
//    _imageCarouselView = [[ImageCarouselView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width* 0.84 * 0.6) withDelegate:self];
//    _imageCarouselView.showTime = 1;
//    _imageCarouselView.imageArray = self.cellInfoArray;
//    [_imageCarouselView reloadView];
    
    _imageWidth = self.view.bounds.size.width - Item_Margin*4;
    _imageHeight = _imageWidth*340.0/750.0;
    _imageCarouselView = [[ImageCarouselView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, _imageHeight+5) withDelegate:self];
    _imageCarouselView.timeInterval = 1;
    _imageCarouselView.spacingWidth = Item_Margin;
    _imageCarouselView.carouselViewWidth = _imageWidth;
    
    [self.view addSubview:_imageCarouselView];
    
    [self.imageCarouselView reloadView:self.cellInfoArray];
    [self.imageCarouselView timerStart];
    
    _labelOne = [[UILabel alloc] initWithFrame:CGRectMake(100, 320, 200, 40)];
    _labelOne.text = @"滚动到了第 0 页";
    _labelOne.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_labelOne];
    
    _labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(100, 360, 200, 40)];
    _labelTwo.text = @"点击了第 X 页";
    _labelTwo.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_labelTwo];
}



- (void)carouselView:(ImageCarouselView *)carouselView didScrollToPage:(NSInteger)pageNumber {
    _labelOne.text = [NSString stringWithFormat:@"滚动到了第 %zd 页", pageNumber];
    [_imageCarouselView timerStart];
}

- (void)carouselView:(ImageCarouselView *)carouselView didSelectPageAtIndex:(NSInteger)index {
    _labelTwo.text = [NSString stringWithFormat:@"点击了第 %zd 页", index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
