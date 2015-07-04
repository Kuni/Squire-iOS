//
//  SQScrollView.h
//  Squire-iOS
//
//  Created by Ben on 2015/7/4.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQScrollView : UIScrollView

@property(nonatomic, weak)UILabel   *textLabel;
@property(nonatomic, weak)UILabel   *detailView;

@property(nonatomic, weak)UIWebView *webView;

@end
