//
//  ELCityMapViewController.h
//  ElanicTest
//
//  Created by Manohar T on 03/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ELCityMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *hederView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(assign,nonatomic) double latitude;
@property(assign,nonatomic) double longitude;

- (IBAction)goBack:(id)sender;

@end
