//
//  Map1ViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-20.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "Map1ViewController.h"
#import "MapViewController.h"

@interface Map1ViewController ()<MapViewControllerDidSelectDelegate>
{
}
@end

@implementation Map1ViewController

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
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"30.281843",@"latitude",@"120.102193",@"longitude",nil];
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:@"30.290144",@"latitude",@"120.146696‎",@"longitude",nil];
    
    NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"30.248076",@"latitude",@"120.164162‎",@"longitude",nil];
    
    NSDictionary *dic4=[NSDictionary dictionaryWithObjectsAndKeys:@"30.425622",@"latitude",@"120.299605",@"longitude",nil];
    
    NSArray *array = [NSArray arrayWithObjects:dic1,dic2,dic3,dic4, nil];
    
     MapViewController *_mapViewController;
    if (iPhone5)
    {
        _mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    }
    else
    {
      _mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController4" bundle:nil];
    }
	
    _mapViewController.delegate = self;
    [self.view addSubview:_mapViewController.view];
    [_mapViewController.view setFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height)];
    [_mapViewController resetAnnitations:array];
}
- (void)customMKMapViewDidSelectedWithInfo:(id)info
{
    NSLog(@"%@",info);
}



@end
