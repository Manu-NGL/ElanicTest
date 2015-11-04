//
//  ViewController.m
//  ElanicTest
//
//  Created by Manohar T on 01/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ViewController.h"
#import "ELCitiesListController.h"
#import <CoreLocation/CoreLocation.h>
#import "ELListCell.h"
#import "ELItem.h"
#import "ELDataManager.h"
#import "ELAPIManager.h"

@interface ViewController () <UITextFieldDelegate>

@property(strong, nonatomic)UIView *blockingView;
@property(strong, nonatomic)UIActivityIndicatorView *activityIndictorView;
@property (strong, nonatomic) IBOutlet UIView *radiusView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property(strong, nonatomic)ELItem *selectedItem;

- (IBAction)radiusOkButtonTapped:(UIButton *)sender;

@end

@implementation ViewController

-(UIView *)blockingView
{
    if(!_blockingView)
    {
        _blockingView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_blockingView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapped)];
        [self.blockingView addGestureRecognizer:tapGesture];
    }
    return _blockingView;
}

-(UIActivityIndicatorView *)activityIndictorView
{
    if(!_activityIndictorView)
    {
        _activityIndictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndictorView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpLocation];
    [ELDataManager sharedDataManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpLocation
{
    CLLocationManager *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    
    latitude = 12.94082;
    longitude = 77.62255;
    
     [[ELAPIManager sharedManager] setLatitude:latitude];
     [[ELAPIManager sharedManager] setLongitude:longitude];
}


-(void)gestureTapped
{
    [self.textField resignFirstResponder];
}

#pragma mark -
#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows= 6;
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELListCell *cell = nil;
    static NSString *cellIdentifier = @"ListCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    ELDataManager *datamanager = [ELDataManager sharedDataManager];
    
    
    NSString *title = @"";
    switch (indexPath.row)
    {
        case 0:
            title = datamanager.food.title;
            break;
            
        case 1:
            title = datamanager.gym.title;
            break;
            
        case 2:
            title = datamanager.hospital.title;
            break;
            
        case 3:
            title = datamanager.restaurant.title;
            break;
            
        case 4:
            title = datamanager.school.title;
            break;
            
        case 5:
            title = datamanager.spa.title;
            break;
            
        default:
            break;
    }
    
    cell.label.text = title;
    return cell;
}

#pragma mark -
#pragma mark - UITableView Delegate

-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ELDataManager *datamanager = [ELDataManager sharedDataManager];
    
    switch (indexPath.row)
    {
        case 0:
            self.selectedItem = datamanager.food;
            break;
            
        case 1:
            self.selectedItem = datamanager.gym;
            break;
            
        case 2:
            self.selectedItem = datamanager.hospital;
            break;
            
        case 3:
            self.selectedItem = datamanager.restaurant;
            break;
            
        case 4:
            self.selectedItem = datamanager.school;
            break;
            
        case 5:
            self.selectedItem = datamanager.spa;
            break;
            
        default:
            break;
    }

    
    [self.view addSubview:self.blockingView];
    [self.radiusView setCenter:self.view.center];
    [self.view addSubview:self.radiusView];
    self.radiusView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    [UIView animateWithDuration:0.5 animations:^{
        self.radiusView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (IBAction)radiusOkButtonTapped:(UIButton *)sender
{
    if(![self.textField.text isEqualToString:@""])
    {
        [self.radiusView removeFromSuperview];
        [self.textField resignFirstResponder];
        
        [self.view addSubview:self.activityIndictorView];
        [self.activityIndictorView setCenter:self.view.center];
        [self.view bringSubviewToFront:self.activityIndictorView];
        [self.activityIndictorView startAnimating];
        
        [[ELAPIManager sharedManager] fetchPlacesForItem:self.selectedItem.title withintheRadius:self.selectedItem.radius WithCompletion:^(NSArray *places, NSError *error)
         {
             [self.activityIndictorView removeFromSuperview];
             [self.blockingView removeFromSuperview];
             
             if([places count] > 0)
             {
                 self.selectedItem.cities = [NSArray arrayWithArray:places];
                 ELCitiesListController *citiesListController  = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesListController"];
        
                 [citiesListController setCitiesList:self.selectedItem.cities];
                 [self.navigationController pushViewController:citiesListController animated:YES];
             }
             else
             {
                 
             }
         }];

    }
}

#pragma mark -
#pragma mark - UItextField Delegate

-(void)textFieldDidEndEditing:(nonnull UITextField *)textField
{
    self.selectedItem.radius = textField.text;
}

@end
