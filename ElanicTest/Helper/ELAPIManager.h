//
//  ELAPIManager.h
//  ElanicTest
//
//  Created by Manohar T on 02/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELAPIManager : NSObject

@property(assign, nonatomic)float latitude;
@property(assign, nonatomic)float longitude;


+(instancetype)sharedManager;


-(void)fetchPlacesForItem:(NSString *)item withintheRadius:(NSString *)radius WithCompletion:(void (^)(NSArray *places, NSError *error))completion;

@end
