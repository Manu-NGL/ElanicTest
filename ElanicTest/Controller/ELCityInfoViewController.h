//
//  ELCityInfoViewController.h
//  ElanicTest
//
//  Created by Manohar T on 03/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCity.h"

@interface ELCityInfoViewController : UIViewController

@property (strong, nonatomic) ELCity *city;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIView *hederView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingContenLabel;
@property (weak, nonatomic) IBOutlet UILabel *vicinitContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)goBack:(id)sender;

@end
