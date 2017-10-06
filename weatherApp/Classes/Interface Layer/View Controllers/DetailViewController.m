//
//  DetailViewController.m
//  weatherApp
//
//  Created by Alexander Bakuta on 05/10/2017.
//

#import "DetailViewController.h"
#import "NetworkManager.h"

NSString* const kTitleDetailScreen  = @"Historical Info";

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel                 *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *minTempLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
}

#pragma mark -
#pragma mark Private

- (void)_setup {
    self.title = kTitleDetailScreen;
    
    [self.activityView startAnimating];
    [[NetworkManager shared] getHistoryFiveDaysBycityID:_city.identifier
                                      completionHadnler:^(CityModel* city, NSError *error) {
        [self _updateUIWithCity:city];
    }];
}

- (void)_updateUIWithCity:(CityModel*)city {
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    
    self.cityNameLabel.text = city.name;
    self.maxTempLabel.text = [NSString stringWithFormat:@"%ldC", (long)city.temp_max];
    self.minTempLabel.text = [NSString stringWithFormat:@"%ldC", (long)city.temp_min];
}

@end
