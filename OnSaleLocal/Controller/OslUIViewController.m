//
//  OslUIViewController.m
//  OnSaleLocal
//
//  Created by Kevin Zhang on 12/14/13.
//  Copyright (c) 2013 junyuan ji. All rights reserved.
//

#import "OslUIViewController.h"

@interface OslUIViewController ()

@end

@implementation OslUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataChangedTime = 0;
    self.appearTime = 0;
    self.disappearTime = 0;
}

- (void)viewDidunload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataChanged" object:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.disappearTime = [[NSDate date] timeIntervalSince1970];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChangedNotificationCallback:) name:@"dataChangedNotification" object:nil];
    NSLog(@"addObserver dataChangedNotification");
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataChangedNotification" object:nil];
    self.appearTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"removeObserver dataChangedNotification");
}

-(BOOL) isAppearing
{
    return self.appearTime > self.disappearTime;
}

-(void)dataChangedNotificationCallback:(NSNotification *)noti
{
    self.dataChangedTime = [[NSDate date] timeIntervalSince1970];
}

-(BOOL) dataChanged
{
    return self.dataChangedTime > self.disappearTime;
}
@end
