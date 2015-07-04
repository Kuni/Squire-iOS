//
//  SQSquireEditor.m
//  Squire-iOS
//
//  Created by CHENHSIN-PANG on 2015/5/4.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import "SQSquireEditor.h"
#import <objc/runtime.h>


NSString *const SQSquireEditorFrameChange = @"SQSquireEditorFrameChange";

@interface SQSquireEditor ()<UIWebViewDelegate>

@property(nonatomic, weak)UIWebView *webView;

@end


@implementation SQSquireEditor


-(instancetype)initWithWebView:(UIWebView*)webView
{
    self = [super init];
    if(self)
    {

        self.webView = webView;
        self.webView.delegate = self;
        self.webView.scalesPageToFit = NO;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.backgroundColor = [UIColor clearColor];
        self.webView.scrollView.clipsToBounds = NO;
        self.webView.backgroundColor = [UIColor clearColor];
        [self loadEditor];
        
        //[self startObservingContentSizeChangesInWebView:self.webView];
        
    }
    
    return self;
}



-(void)loadEditor
{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"squire-editor" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}




#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([request.URL.scheme isEqualToString:@"squire-editor"])
    {
        NSLog(@"path = %@", request.URL);
        
        
        NSLog(@"host = %@", request.URL.host);
        
        if([request.URL.host isEqualToString:@"notification"])
        {
            // 拿出query
            NSString *query = request.URL.query;
            NSArray *components = [query componentsSeparatedByString:@"="];
            NSString *height = components.lastObject;
            CGRect frame = self.webView.frame;
            frame.size.height = [height integerValue];
            self.webView.frame = frame;
            //self.webView.scrollView.contentOffset = CGPointZero;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SQSquireEditorFrameChange object:nil];
            
        }
        
        return NO;
    }

    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self resizeEditorView];
//
//    CGSize size = self.webView.scrollView.contentSize;
//    NSLog(@"size = %@", NSStringFromCGSize(size));
//
    
    [self resizeEditorView];
}



-(void)resizeEditorView
{
    [self iframeResizeWithSize:self.webView.frame.size];
}




#pragma mark - Customize
-(void)iframeResizeWithSize:(CGSize)size
{
    NSString *command = [NSString stringWithFormat:@"iframe.resize(%f,%f);", size.width, size.height];
    [self.webView stringByEvaluatingJavaScriptFromString:command];
}




#pragma mark - Private

-(void)runCommandWithString:(NSString*)command
{
    NSLog(@"command = %@", command);
    [self.webView stringByEvaluatingJavaScriptFromString:command];
}


-(NSString*)getHTML
{
    NSString *command = [NSString stringWithFormat:@"editor.getHTML();"];
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:command];
    NSLog(@"result = %@", result);
    
    return result;
}

-(void)setHTML:(NSString*)html
{
    
    html = [html stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
    NSLog(@"html = %@", html);
    NSString *command = [NSString stringWithFormat:@"editor.setHTML(\"%@\");", html];
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:command];
    NSLog(@"result = %@", result);
    //
    [self flattenWebView];

}

-(void)flattenWebView
{
    CGSize size = self.webView.scrollView.contentSize;
    CGRect frame = self.webView.frame;
    frame.size = size;
    self.webView.frame = frame;

}


-(void)increaseListLevel
{
    NSString *command = [NSString stringWithFormat:@"cr_bridge('increaseQuoteLevel()');"];
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:command];
    NSLog(@"result = %@", result);
}



// This is deprecated
#pragma mark - Observe the changes from the scrollView of webView
//static int kObservingContentSizeChangesContext;
//
//- (void)startObservingContentSizeChangesInWebView:(UIWebView *)webView {
//    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:&kObservingContentSizeChangesContext];
//}
//
//- (void)stopObservingContentSizeChangesInWebView:(UIWebView *)webView {
//    [webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:&kObservingContentSizeChangesContext];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (context == &kObservingContentSizeChangesContext) {
////        UIScrollView *scrollView = object;
////        NSLog(@"%@ contentSize changed to %@", scrollView, NSStringFromCGSize(scrollView.contentSize));
////        CGSize size = self.webView.scrollView.contentSize;
////        
////        NSLog(@"size = %@", NSStringFromCGSize(size));
////        
////        CGRect frame = self.webView.frame;
////        frame.size = size;
////        self.webView.frame = frame;
//
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}


#pragma mark - Dynamic Command

// 用來處理對Webview的Javascript bridge

void dynamicMethodIMP(id self, SEL _cmd) {
    // implementation ....
    
    NSString *command = NSStringFromSelector(_cmd);
    NSString *commandStr = [NSString stringWithFormat:@"editor.%@();", command];
    [self runCommandWithString:commandStr];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    // detect bridge command
    NSString *selString = NSStringFromSelector(aSEL);
    
    NSArray *bridge = @[@"bold", @"increaseListLevel", @"decreaseListLevel"]; // 限制可以Bridge的Methods
    
    if([bridge containsObject:selString])
    {
        class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:aSEL];
}



@end
