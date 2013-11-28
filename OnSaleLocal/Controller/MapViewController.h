//
//  MapViewController.h
//  OnSaleLocal
//
//  Created by junyuan ji on 13-9-20.
//  Copyright (c) 2013年 junyuan ji. All rights reserved.
//

//#import "BaseViewController.h"
//#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
//
//
//@protocol MapViewControllerDelegate;

//@interface MapViewController : BaseViewController
//@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
//@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
//@property (strong, nonatomic) CLLocation* pinLocation;
//@property (strong, nonatomic) CLLocation* currentLocation;
//@end

//@protocol MapViewControllerDelegate <NSObject>
//- (UIImageView *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
//@end

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "BaseViewController.h"

@protocol MapViewControllerDidSelectDelegate;
@interface MapViewController : UIViewController<MKMapViewDelegate>
{
    MKMapView *_mapView;
    
    
    id<MapViewControllerDidSelectDelegate> delegate;
}
@property(nonatomic,strong)IBOutlet MKMapView *mapView;

@property(nonatomic)id<MapViewControllerDidSelectDelegate> delegate;

- (void)resetAnnitations:(NSArray *)data;
@end

@protocol MapViewControllerDidSelectDelegate <NSObject>

@optional
- (void)customMKMapViewDidSelectedWithInfo:(id)info;

@end