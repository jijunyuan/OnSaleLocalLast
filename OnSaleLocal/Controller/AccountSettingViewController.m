//
//  AccountSettingViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "AccountSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+UIImageExt.h"
#import "SetViewController.h"
#import "AppDelegate.h"
#import "UIButton+ClickEvent.h"

@interface AccountSettingViewController ()<NSURLConnectionDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isFaceBook;
    NSString * genderStr;
    NSHTTPURLResponse * response1;
    NSMutableData * reciveData;
    NSMutableURLRequest * request_yes;
    NSMutableURLRequest * request_no;
    NSData * imageData;
    NSMutableURLRequest * upRequest;
    NSString * remeberPWD;
    
    UIImagePickerController * pickViewController;
}
@property (nonatomic,strong) IBOutlet UIScrollView * myScrollView;
@property (nonatomic,strong) IBOutlet UIImageView * IV_photo;
@property (nonatomic,strong) IBOutlet UITextField * TF_firstName;
@property (nonatomic,strong) IBOutlet UITextField * TF_lastName;
@property (nonatomic,strong) IBOutlet UITextField * TF_email;
@property (nonatomic,strong) IBOutlet UITextField * TF_password;
@property (nonatomic,strong) IBOutlet UITextField * TF_zipcode;

@property (nonatomic,strong) IBOutlet UIButton * Btn_male;
@property (nonatomic,strong) IBOutlet UIButton * Btn_female;
@property (nonatomic,strong) IBOutlet UIButton * Btn_nosay;
@property (nonatomic,strong) IBOutlet UIButton * Btn_facebook;
@property (nonatomic,strong) IBOutlet UISwitch * SW_notification;
@property (nonatomic,strong) IBOutlet UIView * V_iphone4;

@property (nonatomic,strong) IBOutlet UIButton * bt_1;
@property (nonatomic,strong) IBOutlet UIButton * bt_2;
@property (nonatomic,strong) IBOutlet UIButton * bt_3;
@property (nonatomic,strong) IBOutlet UILabel * l_11;

@property (nonatomic,strong) IBOutlet UILabel * L_facebook;

@property (nonatomic,strong) IBOutlet UILabel * L_desNotification;
@property (nonatomic,strong) IBOutlet UILabel * L_desPush;

-(IBAction)maleClick:(id)sender;
-(IBAction)femaleClick:(id)sender;
-(IBAction)nosayClick:(id)sender;
-(IBAction)faceBtnClick:(id)sender;
-(void)saveClick;
-(IBAction)turnNotification:(id)sender;
-(void)photoClick:(id)sender;
-(void)uploadPhotoImage;

- (BOOL)validateEmail:(NSString *)emailStr;
- (BOOL)isValidZip:(NSString *)aZip;
- (BOOL)isPureInt:(NSString *)string;
- (BOOL)isPureFloat:(NSString *)string;
-(void)textChaged:(UITextField *)aTextField;
@end

@implementation AccountSettingViewController
@synthesize IV_photo;
@synthesize TF_email;
@synthesize TF_firstName;
@synthesize TF_lastName;
@synthesize TF_password;
@synthesize TF_zipcode;
@synthesize L_facebook;

@synthesize SW_notification;
@synthesize Btn_facebook;
@synthesize Btn_female;
@synthesize Btn_male;
@synthesize Btn_nosay;
@synthesize V_iphone4;
@synthesize setController;
@synthesize myScrollView;
@synthesize bt_1;
@synthesize bt_2;
@synthesize bt_3;
@synthesize l_11;
@synthesize L_desNotification,L_desPush;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    // [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    genderStr = @"NoToSay";
    self.TF_email.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_firstName.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_lastName.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_password.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.TF_zipcode.font = [UIFont fontWithName:AllFont size:AllContentSize];
    // self.L_facebook.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.bt_1.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.bt_2.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.bt_3.titleLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.l_11.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    self.rightBtn.frame = CGRectMake(self.rightBtn.frame.origin.x, self.rightBtn.frame.origin.y, 30, 30);
    self.L_desPush.font = [UIFont fontWithName:AllFont size:AllContentSize];
    self.L_desNotification.font = [UIFont fontWithName:AllFont size:AllContentSize];
    
    pickViewController = [[UIImagePickerController alloc]init];
    
    if (!iPhone5)
    {
        UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 480)];
        self.myScrollView = scrollview;
        scrollview.contentSize = CGSizeMake(320, self.V_iphone4.frame.size.height+30);
        [scrollview addSubview:self.V_iphone4];
        [self.view addSubview:scrollview];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_STATUS] isEqualToString:@"1"])
    {
        self.L_facebook.alpha = 1.0;
    }
    else
    {
        self.L_facebook.alpha = 0.0;
    }
    
    NSString * imageStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_IMAGE]];
    NSLog(@"imagestr = %@",imageStr);
    if ([imageStr isEqualToString:@"(null)"])
    {
        self.IV_photo.image = [UIImage imageNamed:@"avatar_80x80.png"];
    }
    else
    {
        [MyActivceView startAnimatedInView2:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageStr]];
            NSData * tempData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MyActivceView stopAnimatedInView:self.view];
                self.IV_photo.image = [UIImage imageWithData:tempData];
            });
        });
    }
    self.l_navTitle.font = [UIFont fontWithName:AllFontBold size:All_h2_size];
    self.l_navTitle.text = [@"Account Settings" uppercaseString];
    self.rightBtn.backgroundColor = [UIColor whiteColor];
    self.TF_password.secureTextEntry = YES;
    
    self.Btn_facebook.layer.borderColor = [UIColor blackColor].CGColor;
    self.Btn_facebook.layer.borderWidth = 2;
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    self.TF_firstName.text = [user valueForKey:LOGIN_FIRST_NAME];
    self.TF_lastName.text = [user valueForKey:LOGIN_LAST_NAME];
    self.TF_email.text = [user valueForKey:LOGIN_LOGIN];
    
    //    remeberPWD = [user valueForKey:LOGIN_PASSWORD];
    //    NSString * tempStr;
    //    if ([[user valueForKey:LOGIN_PASSWORD] length]>5)
    //    {
    //        tempStr = [[user valueForKey:LOGIN_PASSWORD] substringWithRange:NSMakeRange(0, 6)];
    //    }
    //    else
    //    {
    //        tempStr = [user valueForKey:LOGIN_PASSWORD];
    //    }
    self.TF_password.text = [user valueForKey:LOGIN_PASSWORD];
    [self.TF_password addTarget:self action:@selector(textChaged:) forControlEvents:UIControlEventEditingChanged];
    
    self.TF_zipcode.text = [user valueForKey:LOGIN_ZIPCODE];
    NSString * str1 = [NSString stringWithFormat:@"%@",[user valueForKey:LOGIN_GENDER]];
    //Man"Woman";NoToSay";
    if ([str1 isEqualToString:@"Man"])
    {
        // self.Btn_male.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        self.Btn_male.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
        self.Btn_male.titleLabel.textColor = [UIColor whiteColor];
        self.Btn_female.backgroundColor = [UIColor whiteColor];
        self.Btn_nosay.backgroundColor = [UIColor whiteColor];
    }
    else if ([str1 isEqualToString:@"Woman"])
    {
        self.Btn_male.backgroundColor = [UIColor whiteColor];
        //self.Btn_female.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];;
        self.Btn_female.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
        self.Btn_female.titleLabel.textColor = [UIColor whiteColor];
        self.Btn_nosay.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.Btn_male.backgroundColor = [UIColor whiteColor];
        self.Btn_female.backgroundColor = [UIColor whiteColor];
        // self.Btn_nosay.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];;
        self.Btn_nosay.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
        self.Btn_nosay.titleLabel.textColor = [UIColor whiteColor];
    }
    
    if ([[user valueForKey:LOGIN_NOTI] isEqualToString:@"Enable"])
    {
        self.SW_notification.on = YES;
    }
    else
    {
        self.SW_notification.on = NO;
    }
    
    
    //    self.rightBtn.titleLabel.font = [UIFont fontWithName:AllFont size:AllFontSize];
    //    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self.rightBtn setTitle:@"save" forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(saveClick) forControlEvents:UIButtonClickEvent];
    // self.rightBtn.backgroundColor = [UIColor whiteColor];
    
    self.IV_photo.userInteractionEnabled = YES;
    UITapGestureRecognizer * photoTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
    [self.IV_photo addGestureRecognizer:photoTap];
    
    self.IV_photo.layer.cornerRadius = 40;
}
-(void)textChaged:(UITextField *)aTextField
{
    NSLog(@"%s",__FUNCTION__);
    remeberPWD = aTextField.text;
}
-(IBAction)turnNotification:(id)sender
{
    if (self.SW_notification.on)
    {
        request_yes = [WebService TurnonNotification];
        NSURLResponse * response2;
        NSError * error;
        NSData * data = [NSURLConnection sendSynchronousRequest:request_yes returningResponse:&response2 error:&error];
        NSLog(@"on = %@",[[NSString alloc] initWithData:data encoding:4]);
        NSHTTPURLResponse * httpRes = (NSHTTPURLResponse *)response2;
        if (httpRes.statusCode == 200)
        {
            //  [MyAlert ShowAlertMessage:@"Success" title:@""];
            [[NSUserDefaults standardUserDefaults] setValue:@"Enable" forKey:LOGIN_NOTI];
        }
        else
        {
            // [MyAlert ShowAlertMessage:@"Sever appears error." title:@""];
            self.SW_notification.on = NO;
        }
    }
    else
    {
        request_no = [WebService TurnoffNotification];
        [NSURLConnection connectionWithRequest:request_no delegate:self];
        [[NSUserDefaults standardUserDefaults] setValue:@"noEnable" forKey:LOGIN_NOTI];
    }
}

-(void)saveClick
{
    if ([WebService isConnectionAvailable])
    {
        if (self.TF_firstName.text.length>0 && self.TF_lastName.text.length>0 && self.TF_email.text.length>0 && self.TF_password.text.length>0 && self.TF_zipcode.text.length>0)
        {
            if ([self validateEmail:self.TF_email.text])
            {
                if ([self isValidZip:self.TF_zipcode.text])
                {
                    [MyActivceView startAnimatedInView:self.view];
                    NSLog(@"remberPED = %@",remeberPWD);
                    NSMutableURLRequest * request = [WebService UpdateUserInfoFirstName:self.TF_firstName.text lastName:self.TF_lastName.text email:self.TF_email.text password:self.TF_password.text zipcode:self.TF_zipcode.text gender:genderStr birthday:2012];
                    [NSURLConnection connectionWithRequest:request delegate:self];
                }
                else
                {
                    [MyAlert ShowAlertMessage:@"ZIP code is incorrect." title:@"Alert"];
                }
            }
            else
            {
                [MyAlert ShowAlertMessage:@"Email code is incorrect." title:@"Alert"];
            }
            
        }
        else
        {
            [MyAlert ShowAlertMessage:@"Information is incomplete." title:@"Alert"];
        }
    }
}
-(IBAction)maleClick:(id)sender
{
    genderStr = @"Man";
    // self.Btn_male.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    self.Btn_male.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
    
   // self.Btn_male.titleLabel.textColor = [UIColor whiteColor];
    [self.Btn_male setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
   [self.Btn_female setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.Btn_nosay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.Btn_nosay.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:255.0/255.0];
    self.Btn_female.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:255.0/255.0];
}
-(IBAction)femaleClick:(id)sender
{
    genderStr = @"Woman";
    self.Btn_male.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.Btn_nosay.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:255.0/255.0];
    //self.Btn_female.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:255.0/255.0];
    self.Btn_female.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
    [self.Btn_female setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [self.Btn_male setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [self.Btn_nosay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)nosayClick:(id)sender
{
    genderStr = @"NoToSay";
    self.Btn_male.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    // self.Btn_nosay.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:255.0/255.0];
    self.Btn_nosay.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:0 blue:0 alpha:1.0];
    [self.Btn_nosay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.Btn_female setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.Btn_male setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.Btn_female.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:255.0/255.0];
}
-(IBAction)faceBtnClick:(id)sender
{
    if (isFaceBook)
    {
        isFaceBook = NO;
        [self.Btn_facebook setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        isFaceBook = YES;
        [self.Btn_facebook setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MyActivceView stopAnimatedInView:self.view];
    //[MyAlert ShowAlertMessage:@"Not to force the network" title:@""];
    if ((NSMutableURLRequest *)[connection currentRequest] == request_no)
    {
        self.SW_notification.on = NO;
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [MyActivceView startAnimatedInView:self.view];
    reciveData = [NSMutableData dataWithCapacity:0];
    response1 = (NSHTTPURLResponse *)response;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [reciveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MyActivceView stopAnimatedInView:self.view];
    if ([response1 statusCode] == 200)
    {
        if ((NSMutableURLRequest *)[connection currentRequest] == request_no)
        {
            // [MyAlert ShowAlertMessage:@"Save Success" title:@""];
        }
        else
        {
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setValue:self.TF_firstName.text forKey:LOGIN_FIRST_NAME];
            [user setValue:self.TF_lastName.text forKey:LOGIN_LAST_NAME];
            [user setValue:self.TF_email.text forKey:LOGIN_LOGIN];
            [user setValue:self.TF_password.text forKey:LOGIN_PASSWORD];
            [user setValue:self.TF_zipcode.text forKey:LOGIN_ZIPCODE];
            [user setValue:genderStr forKey:LOGIN_GENDER];
            [self.TF_password resignFirstResponder];
            [self.TF_zipcode resignFirstResponder];
            [self.TF_lastName resignFirstResponder];
            [self.TF_firstName resignFirstResponder];
            [self.TF_email resignFirstResponder];
            
            [MyAlert ShowAlertMessage:@"Save Success！" title:@""];
        }
    }
    else
    {
        // [MyAlert ShowAlertMessage:[NSString ErrorCodeAndErrorMsgFromReciveData:reciveData] title:@""];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.rightBtn.alpha =1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myScrollView.contentOffset = CGPointMake(0, 0);
    }];
    [self.TF_password resignFirstResponder];
    [self.TF_zipcode resignFirstResponder];
    [self.TF_lastName resignFirstResponder];
    [self.TF_firstName resignFirstResponder];
    [self.TF_email resignFirstResponder];
}
-(void)photoClick:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture",@"Choose from album", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showFromRect:CGRectMake(0, 100, 320, 300) inView:self.view animated:self];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)  //take a picture
    {
        if ([WebService ISIOS7])
        {
            [pickViewController.view removeFromSuperview];
            pickViewController.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, 320, [UIScreen mainScreen].bounds.size.height-20);
            self.view.clipsToBounds = YES;
            [self.view addSubview:pickViewController.view];
            
        }
        pickViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickViewController.delegate = self;
        if ([WebService ISIOS7])
        {
            [UIView animateWithDuration:0.3 animations:^{
//                pickViewController.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20);
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
            [self presentModalViewController:pickViewController animated:YES];
        }
    }
    if (buttonIndex == 1)  //choose from album
    {
        if ([WebService ISIOS7])
        {
            pickViewController.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, 320, [UIScreen mainScreen].bounds.size.height-20);
            [self.view addSubview:pickViewController.view];
        }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = normalizedImage;
    imageData = UIImageJPEGRepresentation(image, 0.001);
    
    if ([WebService ISIOS7])
    {
        [UIView animateWithDuration:0.3 animations:^{  
        }];
        [UIView animateWithDuration:0.3 animations:^{
//            pickViewController.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, 320, [UIScreen mainScreen].bounds.size.height-20);
            [self updateUIStatus];
        } completion:^(BOOL finished) {
            self.IV_photo.image = [image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
            [self uploadPhotoImage];
            [self backIOS7];
        }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            self.IV_photo.image = [image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
            [self uploadPhotoImage];
           
        }];
        //[self dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([WebService ISIOS7])
    {
        [UIView animateWithDuration:0.3 animations:^{
           // pickViewController.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, 320, [UIScreen mainScreen].bounds.size.height-20);
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


-(void)uploadPhotoImage
{
    upRequest = [WebService uploadImageData:imageData];
    NSURLResponse * respones2 = [[NSURLResponse alloc] init];
    NSData * data3 = [NSURLConnection sendSynchronousRequest:upRequest returningResponse:&respones2 error:nil];
    NSHTTPURLResponse * res = (NSHTTPURLResponse *)respones2;
    NSLog(@"success data = %@",[[NSString alloc] initWithData:data3 encoding:4]);
    
    if (res.statusCode == 200)
    {
        // [[NSUserDefaults standardUserDefaults] setValue:[UIImage imageWithData:imageData] forKey:LOGIN_IMAGE];
        
        self.setController.IV_login_name.image = [UIImage imageWithData:imageData];
    }
    else
    {
        NSLog(@"fail code = %d",res.statusCode);
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    self.rightBtn.alpha = 0.0;
    
    if (textField.tag == 50 || textField.tag == 51)
    {
        // self.myScrollView.contentOffset = CGPointMake(0, 50);
    }
    if (textField.tag == 52)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.myScrollView.contentOffset = CGPointMake(0, 40);
        }];
        
    }
    if (textField.tag == 53)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.myScrollView.contentOffset = CGPointMake(0, 80);
        }];
    }
    if (textField.tag == 54)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.myScrollView.contentOffset = CGPointMake(0, 120);
        }];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.rightBtn.alpha =1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myScrollView.contentOffset = CGPointMake(0, 0);
    }];
    [self.TF_password resignFirstResponder];
    [self.TF_zipcode resignFirstResponder];
    [self.TF_lastName resignFirstResponder];
    [self.TF_firstName resignFirstResponder];
    [self.TF_email resignFirstResponder];
    return YES;
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (BOOL)isValidZip:(NSString *)aZip
{
    NSString * zipRegex = @"^[1-9]\\d{4}$";
    NSPredicate * zip = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zipRegex];
    return [zip evaluateWithObject:aZip];
}

- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return ([scan scanFloat:&val]||[scan scanHexFloat:&val]) && [scan isAtEnd];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
