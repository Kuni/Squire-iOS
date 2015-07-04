//
//  SQScrollView.m
//  Squire-iOS
//
//  Created by Ben on 2015/7/4.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import "SQScrollView.h"

@implementation SQScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        UILabel *detailView = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.frame), 40)];
        [self addSubview:detailView];
        self.detailView = detailView;
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.frame), 200)];
        [self addSubview:webView];
        self.webView = webView;
        
        
        self.textLabel.backgroundColor = [UIColor redColor];
        self.detailView.backgroundColor = [UIColor orangeColor];
        //self.webView.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = CGRectGetWidth(self.frame);
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailViewFrame = self.detailView.frame;
    detailViewFrame.size.width = CGRectGetWidth(self.frame);
    self.detailView.frame = detailViewFrame;


    CGRect webFrame = self.webView.frame;
    webFrame.size.width = CGRectGetWidth(self.frame);
    self.webView.frame = webFrame;

    
    
    NSLog(@"Layout SubView = %@", NSStringFromCGRect(self.frame));

    CGSize size = self.contentSize;
    
    CGFloat webViewMaxY = CGRectGetMaxY(self.webView.frame);
    
//    if(webViewMaxY > size.height - 20)
//    {
//        size.height = webViewMaxY + 60;
//        self.contentSize = size;
//    }
    
    size.height = webViewMaxY + 20;
    self.contentSize = size;
    
    if(self.contentSize.height < self.frame.size.height)
    {
        CGSize contentSize = self.contentSize;
        contentSize.height = self.frame.size.height;
        self.contentSize = contentSize;
    }
    
    
}




@end
