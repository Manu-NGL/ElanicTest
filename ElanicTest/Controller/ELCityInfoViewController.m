//
//  ELCityInfoViewController.m
//  ElanicTest
//
//  Created by Manohar T on 03/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ELCityInfoViewController.h"

@interface ELCityInfoViewController ()

@end

@implementation ELCityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameContentLabel.text = [NSString stringWithFormat:@"%@",[self.city.info objectForKey:@"name"]];
    self.ratingContenLabel.text = [NSString stringWithFormat:@"%@",[self.city.info objectForKey:@"rating"]];
    self.vicinitContentLabel.text = [NSString stringWithFormat:@"%@",[self.city.info objectForKey:@"vicinity"]];
    
    [self.nameContentLabel sizeToFit];
    [self.vicinitContentLabel sizeToFit];
    
    self.imageView.image = self.image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
