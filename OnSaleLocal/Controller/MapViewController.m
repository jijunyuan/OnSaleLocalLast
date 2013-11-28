//
//  MapViewController.m
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-20.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

//#import "MapViewController.h"
//#import "DealAnnotation.h"
//
//
//@interface MapViewController ()<MKMapViewDelegate>
//@property (nonatomic,strong) IBOutlet MKMapView * mapView1;
//@end
//
//@implementation MapViewController
//@synthesize mapView1;
//@synthesize annotations = _annotations;
//@synthesize delegate = _delegate;
//@synthesize pinLocation = _pinLocation;
//@synthesize currentLocation = _currentLocation;
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.l_navTitle.text = @"Map Location";
//    
//    
//    
////    //CLLocation * location = [[CLLocation alloc] initWithLatitude:37.378536 longitude:-122.086586];
////    CLLocationCoordinate2D location;
////    location.latitude = 37.378536;
////    location.longitude = -122.086586;
////    [self.mapView1 setCenterCoordinate:location];
//    
//}
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
////    DealAnnotation* anno = (DealAnnotation*)annotation;
////    if ([anno.title isEqualToString:CURRENT_LOCATION_ANNOTATION])
////    {
////        MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc]initWithAnnotation:anno reuseIdentifier:CURRENT_LOCATION_ANNOTATION];
////        pinView.pinColor = MKPinAnnotationColorGreen;
////        return pinView;
////    }
//    MKPinAnnotationView * pinView = [[MKPinAnnotationView alloc] init];
//    pinView.pinColor = MKPinAnnotationColorPurple;
//    
//    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
//    if (!aView)
//    {
//        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
//        aView.canShowCallout = YES;
//        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        UIButton* btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        aView.rightCalloutAccessoryView = btn;
//    }
//    //UIButton* btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    //aView.rightCalloutAccessoryView = btn;
//    aView.annotation = annotation;
//    //[(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
//    NSLog(@"%@", aView.rightCalloutAccessoryView);
//    return aView;
//
//}
//-(void)setPinLocation:(CLLocation *)pinLocation
//{
//    _pinLocation = pinLocation;
//    CLLocationDegrees latitude = self.pinLocation.coordinate.latitude;
//    CLLocationDegrees longitude = self.pinLocation.coordinate.longitude;
//    CLLocationCoordinate2D loc2D = CLLocationCoordinate2DMake(latitude, longitude);
//
//    if(![[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        [self.mapView1 setCenterCoordinate:loc2D animated:YES];
//    }
//}
//
//#pragma mark - Synchronize Model and View
//
//- (void)updateMapView
//{
//    if (self.mapView1.annotations) [self.mapView1 removeAnnotations:self.mapView1.annotations];
//    if (self.annotations) [self.mapView1 addAnnotations:self.annotations];
//}
//
//- (void)setMapView:(MKMapView *)mapView
//{
//    [self updateMapView];
//}
//
//- (void)setAnnotations:(NSArray *)annotations
//{
//    _annotations = annotations;
//    [self updateMapView];
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
#import "MapViewController.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#define span 40000

@interface MapViewController ()
{
    NSMutableArray *_annotationList;
    CalloutMapAnnotation *_calloutAnnotation;
	CalloutMapAnnotation *_previousdAnnotation;
}
-(void)setAnnotionsWithList:(NSArray *)list;
@end

@implementation MapViewController
@synthesize mapView=_mapView;
@synthesize delegate;


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
    _annotationList = [[NSMutableArray alloc] init];
    [super viewDidLoad];
}

-(void)setAnnotionsWithList:(NSArray *)list
{
    for (NSDictionary *dic in list) {
        
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span ,span );
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
        [_mapView   addAnnotation:annotation];
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else{
        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
            [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        
        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            [annotationView.contentView addSubview:cell];
            
        }
        return annotationView;
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin.png"];
        }
		
		return annotationView;
    }
	return nil;
}
- (void)resetAnnitations:(NSArray *)data
{
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}
@end
