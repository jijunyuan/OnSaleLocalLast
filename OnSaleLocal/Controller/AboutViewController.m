//
//  AboutViewController.m
//  OnSaleLocal
//
//  Created by tiankong360 on 13-9-14.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

#import "AboutViewController.h"
#import "RateAppViewController.h"
#import "AboutOnsaleViewController.h"
#import "PrivacyViewController.h"
#import "TermsViewController.h"
#import "AboutBackViewController.h"

@interface AboutViewController ()<UIAlertViewDelegate>
{
    NSString * currVision;
    NSString * trackViewURL;
}
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation AboutViewController
@synthesize dataArr;

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
    
    self.l_navTitle.text = @"About";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    currVision = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.dataArr = [NSMutableArray arrayWithObjects:0];
    NSArray * arr1 = [NSArray arrayWithObjects:@"Rate this app",@"Send Feedback", nil];
    NSArray * arr2 = [NSArray arrayWithObjects:@"About Us",@"Team of Use",@"Privacy Policy",@"Version", nil];
   // NSArray * arr3 = [NSArray arrayWithObjects:, nil];
    [self.dataArr addObject:arr1];
    [self.dataArr addObject:arr2];
   // [self.dataArr addObject:arr3];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 30)];
    
    if (section == 0)
    {
        headerLabel.text = @"   This App";
    }
    else
    {
        headerLabel.text = @"   OnSaleLocal";
    }
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:AllFont size:AllFontSize];
    headerLabel.textColor = [UIColor colorWithRed:220.0/256.0 green:24.0/256.0 blue:22.0/256.0 alpha:1.0];
    return headerLabel;
    
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        
//        return @"This App";
//    }
//    else
//    {
//      return @"OnSaleLocal";
//    }
//    return Nil;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:AllFont size:AllContentSize];
        cell.textLabel.textColor = [UIColor blackColor];
        if (indexPath.section == 1&& indexPath.row == 3)
        {
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(200, 7, 100, 30)];
            lab.textColor = [UIColor blackColor];
            lab.text = currVision;
            lab.backgroundColor = [UIColor clearColor];
            lab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lab];
        }
    }
    if (indexPath.section<2 && indexPath.row!=3)
    {
        if (indexPath.section == 0 && indexPath.row == 2)
        {
            ;
        }
        else
        {
         // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView * imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next.png"]];
            imageView1.frame = CGRectMake(0, 0, 20, 20);
            cell.accessoryView= imageView1;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //update vision
    if (indexPath.section == 1 && indexPath.row == 3)
    {
        [self onCheckVersion:currVision];
    }

    if(indexPath.section == 0 && indexPath.row == 0)
    {
        RateAppViewController * rate;
        if(iPhone5)
        {
            rate = [[RateAppViewController alloc] initWithNibName:@"RateAppViewController" bundle:nil];
        }
        else
        {
          rate = [[RateAppViewController alloc] initWithNibName:@"RateAppViewController4" bundle:nil];
        }
        [self.navigationController pushViewController:rate animated:YES];
    }

   if(indexPath.section == 1 && indexPath.row == 0)
   {
       AboutOnsaleViewController * aboutOnsale;
       if(iPhone5)
       {
           aboutOnsale = [[AboutOnsaleViewController alloc] initWithNibName:@"AboutOnsaleViewController" bundle:nil];
       }
       else
       {
        aboutOnsale = [[AboutOnsaleViewController alloc] initWithNibName:@"AboutOnsaleViewController4" bundle:nil];
       }
       [self.navigationController pushViewController:aboutOnsale animated:YES];
   }
  if(indexPath.section == 1 && indexPath.row == 2)
  {
      PrivacyViewController *privacy;
      if(iPhone5)
      {
          privacy = [[PrivacyViewController alloc] initWithNibName:@"AboutOnsaleViewController" bundle:nil];
      }
      else
      {
         privacy = [[PrivacyViewController alloc] initWithNibName:@"AboutOnsaleViewController4" bundle:nil];
      }
      [self.navigationController pushViewController:privacy animated:YES];
  }
  if(indexPath.section == 1 && indexPath.row == 1)
  {
      TermsViewController *term;
      if(iPhone5)
      {
          term = [[TermsViewController alloc] initWithNibName:@"AboutOnsaleViewController" bundle:nil];
      }
      else
      {
          term = [[TermsViewController alloc] initWithNibName:@"AboutOnsaleViewController4" bundle:nil];
      }
      [self.navigationController pushViewController:term animated:YES];
  }
//    if (indexPath.section == 1&& indexPath.row == 0)
//    {
//        AboutOnsaleViewController *aboutBack;
//        if(iPhone5)
//        {
//            aboutBack = [[AboutOnsaleViewController alloc] initWithNibName:@"AboutOnsaleViewController" bundle:nil];
//        }
//        else
//        {
//            aboutBack = [[AboutOnsaleViewController alloc] initWithNibName:@"AboutOnsaleViewController4" bundle:nil];
//        }
//        [self.navigationController pushViewController:aboutBack animated:YES];
//    }
    if (indexPath.section==0&& indexPath.row== 1)
    {
        AboutBackViewController *aboutBack;
        if(iPhone5)
        {
            aboutBack = [[AboutBackViewController alloc] initWithNibName:@"AboutOnsaleViewController" bundle:nil];
        }
        else
        {
            aboutBack = [[AboutBackViewController alloc] initWithNibName:@"AboutOnsaleViewController4" bundle:nil];
        }
        [self.navigationController pushViewController:aboutBack animated:YES];
    }
}
-(void)onCheckVersion:(NSString *)currentVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
  //  NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    
    
    NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&entity=software",appName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSLog(@"====%@",[[NSString alloc] initWithData:recervedData encoding:1]);
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [results objectFromJSONString];
    NSLog(@"dic = %@",dic);
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]>0) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion])
        {
            trackViewURL = [releaseInfo valueForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"A new version, whether to download?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
        }
        else
        {
          [MyAlert ShowAlertMessage:@"This is the latest version." title:@"Alert"];
        }
    }
    else
    {
        [MyAlert ShowAlertMessage:@"This is the latest version." title:@"Alert"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:trackViewURL]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
