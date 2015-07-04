//
//  ViewController.m
//  Squire-iOS
//
//  Created by CHENHSIN-PANG on 2015/5/4.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import "ViewController.h"
#import "SQRichEditorViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)enterEditorView
{
    SQRichEditorViewController *vc = [[SQRichEditorViewController alloc] init];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
    

}



@end
