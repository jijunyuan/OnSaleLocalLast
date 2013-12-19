//
//  FeedBackViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-28.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UIButton+ClickEvent.h"

@interface FeedBackViewController ()
@property (nonatomic,strong) IBOutlet UITextField * TF_subject;
@property (nonatomic,strong) IBOutlet UITextView * TV_content;

-(void)sendClick;
@end

@implementation FeedBackViewController
@synthesize TF_subject,TV_content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.rightBtn setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(sendClick) forControlEvents:UIButtonClickEvent];
}
-(void)sendClick
{
    if (self.TF_subject.text.length>0 && self.TV_content.text.length>0)
    {
        
    }
    else
    {
       // [MyAlert ShowAlertMessage:@"Please fill in the information." title:@""];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
