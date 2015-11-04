//
//  ELDataManager.h
//  ElanicTest
//
//  Created by Manohar T on 02/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELFood.h"
#import "ELGym.h"
#import "ELHospital.h"
#import "ELRestaurant.h"
#import "ELSchool.h"
#import "ELSpa.h"
#import "ELCity.h"

@interface ELDataManager : NSObject

+(instancetype)sharedDataManager;

@property(strong, nonatomic)ELFood *food;
@property(strong, nonatomic)ELGym *gym;
@property(strong, nonatomic)ELSchool *school;
@property(strong, nonatomic)ELHospital *hospital;
@property(strong, nonatomic)ELSpa *spa;
@property(strong, nonatomic)ELRestaurant *restaurant;

@end
