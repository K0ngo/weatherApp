//
//  MapViewController.m
//  weatherApp
//
//  Created by Alexander Bakuta on 05/10/2017.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "NetworkManager.h"
#import "CityModel.h"
#import "DetailViewController.h"

NSString* const kTitleMapScreen  = @"Weather";

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityCoordLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) MKPointAnnotation* annot;
@property (nonatomic) CityModel* city;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
    [self _requestMapkitAccess];
}

#pragma mark -
#pragma mark Actions

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    
    [self.locationManager stopUpdatingLocation];
    
    _mapView.showsUserLocation = NO;
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    self.annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:_annot];
    
    [[NetworkManager shared] getCityWithCoordinateLat:(double)touchMapCoordinate.latitude
                                                  lon:(double)touchMapCoordinate.longitude
                                    completionHadnler:^(CityModel* city, NSError *error) {
        self.city = city;
        [self _updateUIWithCity:city];
    }];
}

- (IBAction)historyButtonPressed:(UIBarButtonItem *)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DetailViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerID"];
    vc.city = _city;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Private Methods

- (void)_setup {
    
    self.title = kTitleMapScreen;
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(handleLongPress:)];
    tap.minimumPressDuration = 0.1;
    [self.mapView addGestureRecognizer:tap];
}

- (void)_updateUIWithCity:(CityModel*)city {
    
    self.cityNameLabel.text = city.name;
    self.tempLabel.text = [NSString stringWithFormat:@"%ldC", (long)city.temp];
    self.cityCoordLabel.text = [NSString stringWithFormat:@"lat:%.4f, lon:%.4f", city.coord.latitude, city.coord.longitude];
    NSString* weatherStr = @"Weather: ";
    for (NSDictionary* weatherDict in city.weather) {
        weatherStr = [weatherStr stringByAppendingString:[NSString stringWithFormat:@"%@ ", weatherDict[@"main"]]];
    }
    self.weatherLabel.text = weatherStr;
}

- (void)_requestMapkitAccess {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark MapKit

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    [[NetworkManager shared] getCityWithCoordinateLat:(double)userLocation.coordinate.latitude
                                                  lon:(double)userLocation.coordinate.longitude
                                    completionHadnler:^(CityModel* city, NSError *error) {
        self.city = city;
        [self _updateUIWithCity:city];
    }];
}

#pragma mark -
#pragma mark Properties Accessors

- (MKPointAnnotation *)annot {
    if (!_annot) {
        _annot = [[MKPointAnnotation alloc] init];
    }
    return _annot;
}

@end
