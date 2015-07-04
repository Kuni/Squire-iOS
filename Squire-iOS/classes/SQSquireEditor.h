//
//  SQSquireEditor.h
//  Squire-iOS
//
//  Created by CHENHSIN-PANG on 2015/5/4.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//
//  The purpose of SQSquireEditor is to communicate between iOS function call with Squire Html5 Editor.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern NSString *const SQSquireEditorFrameChange;


@interface SQSquireEditor : NSObject

-(instancetype)initWithWebView:(UIWebView*)webView;
-(void)resizeEditorView;
-(void)iframeResizeWithSize:(CGSize)size;


-(NSString*)getHTML;
-(void)setHTML:(NSString*)html;
-(void)increaseListLevel;


@end
