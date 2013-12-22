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
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Upload Picture" uppercaseString];
    self.btn_choose.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.frame = CGRectMake(self.rightBtn.frame.origin.x, self.rightBtn.frame.origin.y, 30, 30);
    
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
        [pickViewController.view removeFromSuperview];
        if (iPhone5)
        {
          pickViewController.view.frame = CGRectMake(0, 548+50, 320, 548);
        }
        else
        {
          pickViewController.view.frame = CGRectMake(0, 460+50, 320, 460);
        }
        self.view.clipsToBounds = YES;
        [self.view addSubview:pickViewController.view];
    }
    if (buttonIndex == 0)  //take a picture
    {
        pickViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickViewController.delegate = self;
        if ([WebService ISIOS7])
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (iPhone5)
                {
                   pickViewController.view.frame = CGRectMake(0, 0, 320, 548);
                }
                else
                {
                  pickViewController.view.frame = CGRectMake(0, 0, 320, 460);
                }
            } completion:^(BOOL finished) {
                [self backIOS7];
            }];
        }
        else
        {
            [self presentViewController:pickViewController animated:YES completion:^{
            }];
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
            } completion:^(BOOL finished) {
               // [self backIOS7];
            }];
        }
        else
        {
            [self presentModalViewController:pickViewController animated:YES];
        }
    }
}

-(void)updateUIStatus
{
    UIWindow * theWindow = [UIApplication sharedApplication].delegate.window;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    theWindow.clipsToBounds =YES;
    if (iPhone5)
    {
        pickViewController.view.frame = CGRectMake(0, 548+50, 320, 548);
    }
    else
    {
         pickViewController.view.frame = CGRectMake(0, 460+50, 320, 460);
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage * image1 = [image imageByScalingAndCroppingForSize:image.size];
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
          [self updateUIStatus];
        } completion:^(BOOL finished) {
            [self backIOS7];
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
             [self updateUIStatus];
        } completion:^(BOOL finished) {
            [self backIOS7];
        }];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)choosePictureClick:(id)sender
{
    self.sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture",@"Choose from album", nil];
    self.sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [self.sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)backIOS7
{
    if ([WebService ISIOS7])
    {
        UIWindow * theWindow = [UIApplication sharedApplication].delegate.window;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        theWindow.clipsToBounds =YES;
//        theWindow.bounds =  CGRectMake(0,0,theWindow.frame.size.width,theWindow.frame.size.height-20);
//        theWindow.frame = CGRectMake(0,20,theWindow.frame.size.width,theWindow.frame.size.height);
        if (iPhone5)
        {
            theWindow.bounds =  CGRectMake(0,0,320,548);
            theWindow.frame = CGRectMake(0,20,320,548);
        }
        else
        {
            theWindow.bounds =  CGRectMake(0,0,320,460);
            theWindow.frame = CGRectMake(0,20,320,460);
        }
    }
}



@end
