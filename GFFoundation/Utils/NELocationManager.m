//
//  NELocationManager.m
//  NewsEarn
//
//  Created by nododo on 2018/3/6.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NELocationManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NELocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, copy) void(^locationHandler)(NSString *lat, NSString *lng);

@end

@implementation NELocationManager

+ (NELocationManager *)shareManager{
    static NELocationManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}


- (void)getLocationCoordinate:(void (^)(NSString *lat, NSString *lng))completionHandler {
    _locationHandler = completionHandler;
    [self startLocation];
}

- (void)startLocation {
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [_manager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations.lastObject;
    [self reverseGeocodeWithLocation:newLocation];
    NSString *lat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    self.lat = lat;
    self.lng = lng;
    _locationHandler(lat, lng);
    [self stopLocation];
}

- (void)reverseGeocodeWithLocation:(CLLocation *) location {
    if (!location) {
        return ;
    }
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *mark = [placemarks firstObject];
            [NSUserDefaults.standardUserDefaults setObject:mark.locality forKey:@"locality"];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    _locationHandler(nil, nil);
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_manager startUpdatingLocation];
    } else {
        _locationHandler(nil, nil);
    }
}

- (void)stopLocation {
    [_manager stopUpdatingLocation];
}
@end
