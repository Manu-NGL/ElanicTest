//
//  ELDataManager.m
//  ElanicTest
//
//  Created by Manohar T on 02/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ELDataManager.h"


static NSString *const kFoodKey = @"FoodKey";
static NSString *const kGymKey = @"GymKey";
static NSString *const kSchoolKey  = @"SchoolKey";
static NSString *const kHospitalKey = @"HospitalKey";
static NSString *const kSpaKey = @"SpaKey";
static NSString *const kRestaurantKey = @"RestaurantKey";
static NSString *const kFileKey = @"Items";



@implementation ELDataManager

+(instancetype)sharedDataManager
{
    static ELDataManager *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedController = [self retrieve];
        if(!sharedController)
        {
            sharedController = [[ELDataManager alloc]init];
            sharedController.food = [[ELFood alloc] init];
            sharedController.gym  = [[ELGym alloc] init];
            sharedController.school = [[ELSchool alloc] init];
            sharedController.hospital = [[ELHospital alloc] init];
            sharedController.spa = [[ELSpa alloc] init];
            sharedController.restaurant = [[ELRestaurant alloc] init];

        }
    });
    
    return sharedController;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        _food = [decoder decodeObjectForKey:kFoodKey];
        _gym = [decoder decodeObjectForKey:kGymKey];
        _school = [decoder decodeObjectForKey:kSchoolKey];
        _hospital = [decoder decodeObjectForKey:kHospitalKey];
        _spa = [decoder decodeObjectForKey:kSpaKey];
        _restaurant = [decoder decodeObjectForKey:kRestaurantKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.food forKey:kFoodKey];
    [coder encodeObject:self.gym forKey:kGymKey];
    [coder encodeObject:self.school forKey:kSchoolKey];
    [coder encodeObject:self.hospital forKey:kHospitalKey];
    [coder encodeObject:self.spa forKey:kSpaKey];
    [coder encodeObject:self.restaurant forKey:kRestaurantKey];

}

-(void)save
{
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = @"";
    
    filePath = [cacheDirectoryPath stringByAppendingPathComponent:kFileKey];
    
    BOOL status = [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    if(status)
    {
        NSLog(@"Object Successfully saved");
    }

}

+(ELDataManager *)retrieve
{
    ELDataManager *dataManager = nil;
    
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = @"";
    
    filePath = [cacheDirectoryPath stringByAppendingPathComponent:kFileKey];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dataManager = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    return dataManager;
}


@end
