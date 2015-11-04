//
//  ELCitiesListCell.m
//  ElanicTest
//
//  Created by Manohar T on 03/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ELCitiesListCell.h"

@interface ELCitiesListCell ()

@property (assign, nonatomic)BOOL isMenuViewShown;

@end

@implementation ELCitiesListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwipeGestureRecognizer *swipwGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipwGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.contentView addGestureRecognizer:swipwGestureRight];
    
    UISwipeGestureRecognizer *swipwGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipwGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.contentView addGestureRecognizer:swipwGestureLeft];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}

#pragma mark -
#pragma mark - Interface methods


-(IBAction)menuButtonTappd:(UIButton *)sender 
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(swipeStarted)])
    {
        [self.delegate performSelector:@selector(swipeStarted)];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showMenuForSenderWithTag:)])
    {
        [self.delegate showMenuForSenderWithTag:sender.tag];
    }
    
    [self showMenuViewWithAnimation:YES];
}

-(void)showMenuViewWithAnimation:(BOOL)withAnimation
{
    [self.menuView setHidden:NO];
    [self.menuButton setHidden:YES];
    self.isMenuViewShown = YES;
    
    if(withAnimation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.menuView setFrame:CGRectMake((CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(self.menuView.frame)), 0, CGRectGetWidth(self.menuView.frame), CGRectGetHeight(self.menuView.frame))];
            [self.containerView setFrame:CGRectMake(-30, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame))];
            
        }];
    }
    else
    {
        [self.menuView setFrame:CGRectMake((CGRectGetWidth(self.containerView.frame) - CGRectGetWidth(self.menuView.frame)), CGRectGetMinY(self.menuView.frame), CGRectGetWidth(self.menuView.frame), CGRectGetHeight(self.menuView.frame))];
        [self.containerView setFrame:CGRectMake(-30, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame))];
    }
}


#pragma mark -
#pragma mark - custom methods

-(void)setTitlelabel:(NSString *)title
{
    self.titleLabe.text = title;
}

-(void)setCityImage:(UIImage *)image
{
    self.citImageView.image = image;
}



-(void)showHideStatusImageView:(BOOL)shouldHide
{
    [self.favouriteIcon setHidden:!shouldHide];
}

-(void)setButtonTagsTo:(NSInteger)buttonTag
{
    [self.menuButton setTag:buttonTag];
    [self.mapButton setTag:buttonTag];
    [self.favoriteButton setTag:buttonTag];
}

-(void)hideMenuWithAnimation:(BOOL)shouldAnimate;
{
    self.isMenuViewShown = NO;
    CGFloat offset = 3;
    
    if(shouldAnimate)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.containerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame))];
            [self.menuView setFrame:CGRectMake((CGRectGetWidth(self.containerView.frame) - offset), 0, CGRectGetWidth(self.menuView.frame), CGRectGetHeight(self.menuView.frame))];
            
        } completion:^(BOOL finished) {
            [self.menuButton setHidden:NO];
        }];
    }
    else
    {
        [self.containerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame))];
        [self.menuView setFrame:CGRectMake((CGRectGetWidth(self.containerView.frame) - offset), CGRectGetMinY(self.menuView.frame), CGRectGetWidth(self.menuView.frame), CGRectGetHeight(self.menuView.frame))];
        [self.menuButton setHidden:NO];
        
    }
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(swipeStarted)])
    {
        [self.delegate performSelector:@selector(swipeStarted)];
    }
    if(UISwipeGestureRecognizerDirectionLeft == sender.direction)
    {
        if(!self.isMenuViewShown)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(showMenuForSenderWithTag:)])
            {
                [self.delegate showMenuForSenderWithTag:self.menuButton.tag];
            }
            [self showMenuViewWithAnimation:YES];
        }
    }
    else if(UISwipeGestureRecognizerDirectionRight == sender.direction)
    {
        if(self.isMenuViewShown)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(rightSwipeStarted)])
            {
                [self.delegate rightSwipeStarted];
            }
            [self hideMenuWithAnimation:YES];
        }
    }
}

-(void)updateActivityIndicatorStatus:(BOOL)shouldProgress
{
    if(shouldProgress)
    {
        [self.activtyndicator startAnimating];
    }
    else
    {
        [self.activtyndicator stopAnimating];
    
    }
}

- (IBAction)mapButtonTappd:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(showMapForCity:)])
    {
        [self.delegate showMapForCity:sender];
    }
}

- (IBAction)fvButtonTappd:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(markCityAsFavourite:)])
    {
        [self.delegate markCityAsFavourite:sender];
    }
}
@end
