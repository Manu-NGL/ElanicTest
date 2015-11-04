//
//  ELCitiesListCell.h
//  ElanicTest
//
//  Created by Manohar T on 03/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELCitiesListViewCellDelegate <NSObject>

- (void)showMapForCity:(UIButton *)sender;
- (void)markCityAsFavourite:(UIButton *)sender;
- (void)swipeStarted;
- (void)rightSwipeStarted;
- (void)showMenuForSenderWithTag:(NSInteger)tag;

@end

@interface ELCitiesListCell : UITableViewCell

@property (assign, nonatomic) id<ELCitiesListViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabe;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteIcon;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIImageView *citImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activtyndicator;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;


- (IBAction)menuButtonTappd:(UIButton *)sender;
- (IBAction)mapButtonTappd:(UIButton *)sender;
- (IBAction)fvButtonTappd:(UIButton *)sender;

-(void)setTitlelabel:(NSString *)title;
-(void)setCityImage:(UIImage *)image;
-(void)showHideStatusImageView:(BOOL)shouldHide;
-(void)setButtonTagsTo:(NSInteger)buttonTag;
-(void)showMenuViewWithAnimation:(BOOL)withAnimation;
-(void)hideMenuWithAnimation:(BOOL)shouldAnimate;
-(IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;
-(void)updateActivityIndicatorStatus:(BOOL)shouldProgress;

@end
