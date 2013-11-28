//
//  MKAnnotation.h
//  testMap
//
//  Created by tiankong360 on 13-9-22.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKAnnotation : NSObject<MKAnnotation>
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *title;
-(id) initWithCoords:(CLLocationCoordinate2D) coords;
@end
