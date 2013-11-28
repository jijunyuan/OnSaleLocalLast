//
//  MKAnnotation.m
//  testMap
//
//  Created by tiankong360 on 13-9-22.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "MKAnnotation.h"

@implementation MKAnnotation
@synthesize coordinate,subtitle,title;

- (id)initWithCoords:(CLLocationCoordinate2D) coords
{ 
	self = [super init];
	if (self != nil)
    { 
		self.coordinate = coords;
	}
	return self;
}
@end
