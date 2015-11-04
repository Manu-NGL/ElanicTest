//
//  ELCitiesListController.h
//  ElanicTest
//
//  Created by Manohar T on 03/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELCitiesListController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *hedeView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong, nonatomic)NSArray *citiesList;

- (IBAction)backButtonTapped:(id)sender;
-(void)updateCitiesList:(NSArray *)list;

@end
