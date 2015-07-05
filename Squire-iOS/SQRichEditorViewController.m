//
//  SQRichEditorViewController.m
//  Squire-iOS
//
//  Created by CHENHSIN-PANG on 2015/5/4.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import "SQRichEditorViewController.h"
#import "SQSquireEditor.h"
#import "SQScrollView.h"

@interface SQRichEditorViewController ()<UIActionSheetDelegate>


@property(nonatomic, weak)SQScrollView      *scrollView;

@property(nonatomic, weak)UIWebView         *editorWebView;
@property(nonatomic, strong)SQSquireEditor  *editorController;


@property(nonatomic, assign)CGFloat         keyboradHeight; // tmp

@end

@implementation SQRichEditorViewController


- (void)loadView
{
    SQScrollView *scrollView = [[SQScrollView alloc] initWithFrame:CGRectZero];
    self.view = scrollView;
    self.scrollView = scrollView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    
    // SQSquireEditor必要。
    self.navigationController.navigationBar.translucent = NO;

    self.editorController = [[SQSquireEditor alloc] initWithWebView:self.scrollView.webView];

    
    // Style
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    self.navigationItem.rightBarButtonItems = @[closeItem];

    /// 這個必要的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScrollView) name:SQSquireEditorFrameChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;  // 防止WebBrowserView 因鍵盤上來被移動。
}

-(void)refreshScrollView
{
    NSLog(@"refresh scrollview");
    [self performSelector:@selector(delayRefresh) withObject:nil afterDelay:0.3];
}

-(void)delayRefresh
{
    NSLog(@"delayRefresh offset = %f", self.scrollView.contentSize.height - self.editorController.offsetHeight);
    if(self.scrollView.contentSize.height >= self.scrollView.frame.size.height && self.scrollView.contentSize.height - self.editorController.offsetHeight < 200)
    {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.frame.size.height + self.keyboradHeight);
        //self.scrollView.contentOffset = CGPointMake(0, self.editorController.offsetHeight);
    }
}




-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"ViewDidLayoutSubviews");

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}



-(void)closeAction:(id)sender
{

    [self.editorController getHTML];
    return;
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"setHTML", @"getHTML", @"IncreaseListLevel", nil];
    
    [ac showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %ld", (long)buttonIndex);

    if(buttonIndex == 0)
    {
        NSString *html = @"<blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote>  <blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote> <blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote> <blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote> <blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote>  <blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote> <blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote> <blockquote><a href=\"http://www.apple.com.tw'>Apple</a> Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, online services, and personal computers. Wikipedia</blockquote> ";
        [self.editorController setHTML:html];
    }
    
    
    if(buttonIndex == 1)
    {
        NSString *html = [self.editorController getHTML];
        NSLog(@"html = %@", html);
    }
    
    if(buttonIndex == 2)
    {
        [self.editorController increaseListLevel];
    
    }
    
    
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    CGSize endkbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyboradHeight = endkbSize.height;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, endkbSize.height, 0.0);
 
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        
    } completion:^(BOOL finished) {
        //self.tableView.scrollIndicatorInsets = contentInsets;
    }];
    
}

-(void)keyboardWillBeHidden:(NSNotification*)notification
{
    self.keyboradHeight = 0;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, 0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setNeedsLayout];
    
}



@end
