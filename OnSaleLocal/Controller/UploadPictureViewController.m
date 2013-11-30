//
//  UploadPictureViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-27.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "UploadPictureViewController.h"
#import "PictureClassViewController.h"
#import "UIImage+UIImageExt.h"
#import "AppDelegate.h"

@interface UploadPictureViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSData * imageData;
    UIImagePickerController * pickViewController;
}
@property (nonatomic,strong) IBOutlet UIButton * btn_choose;
-(IBAction)choosePictureClick:(id)sender;
-(void)nextClick;
@end

@implementation UploadPictureViewController
@synthesize imageView;
@synthesize btn_choose;

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
    self.l_navTitle.text = @"Upload Picture";
    self.btn_choose.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    pickViewController = [[UIImagePickerController alloc]init];
    
    if ([WebService ISIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
-(void)nextClick
{
    PictureClassViewController * pick;
    if (iPhone5)
    {
        pick = [[PictureClassViewController alloc] initWithNibName:@"PictureClassViewController" bundle:nil];
    }
   else
   {
       pick = [[PictureClassViewController alloc] initWithNibName:@"PictureClassViewController4" bundle:nil];
   }
    if (!(self.imageView.image == nil))
    {
        pick.imageData = imageData;
        [self.navigationController pushViewController:pick animated:YES];
    }
    else
    {
        [MyAlert ShowAlertMessage:@"Please choose picture!" title:@""];
    }
   
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([WebService ISIOS7])
    {
        if (!pickViewController)
        {
            pickViewController.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, 320, [UIScreen mainScreen].bounds.size.height-20);
            [self.view addSubview:pickViewController.view];
        }
    }
    if (buttonIndex == 0)  //take a picture
    {
        pickViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickViewController.delegate = self;
        if ([WebService ISIOS7])
        {
            [UIView animateWithDuration:0.3 animations:^{
                pickViewController.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20);
            }];
        }
        else
        {
            [self presentModalViewController:pickViewController animated:YES];
        }
    }
    if (buttonIndex == 1)  //choose from album
    {
        pickViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickViewController.delegate =self;
        if ([WebService ISIOS7])
        {
            [UIView animateWithDuration:0.3 animations:^{
                pickViewController.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20);
            }];
        }
        else
        {
            [self presentModalViewController:pickViewController animated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage * image1 = [image imageByScalingAndCroppingForSize:image.size];
    NSLog(@"image1 = %@",image1);
    self.imageView.image = image1;
    
    UIGraphicsBeginImageContextWithOptions(image1.size, NO, image1.scale);
    [image drawInRect:(CGRect){0, 0, image1.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image1 = normalizedImage;
    imageData = UIImageJPEGRepresentation(image1, 0.001);
    if ([WebService ISIOS7])
    {
        [UIView animateWithDuration:0.3 animations:^{
            pickViewController.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, 320, [UIScreen mainScreen].bounds.size.height-20);
        }];
    }
    else
    {
      [self dismissModalViewControllerAnimated:YES];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([WebService ISIOS7])
    {
        [UIView animateWithDuration:0.3 animations:^{
            pickViewController.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, 320, [UIScreen mainScreen].bounds.size.height-20);
        }];
    }
    else
    {
      [self dismissModalViewControllerAnimated:YES];
    }
}
-(IBAction)choosePictureClick:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture",@"Choose from album", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showFromRect:CGRectMake(0, 100, 320, 300) inView:self.view animated:self];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
