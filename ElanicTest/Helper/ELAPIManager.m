//
//  ELAPIManager.m
//  ElanicTest
//
//  Created by Manohar T on 02/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ELAPIManager.h"
#import "ELConstants.h"
#import "ELCity.h"

@implementation ELAPIManager

+(instancetype)sharedManager
{
    static ELAPIManager *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedController = [[ELAPIManager alloc]init];
        
    });
    
    return sharedController;
}

-(void)fetchPlacesForItem:(NSString *)item withintheRadius:(NSString *)radius WithCompletion:(void (^)(NSArray *places, NSError *error))completion
{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@&key=%@", self.latitude, self.longitude, radius ,[item lowercaseString], kGooglePlacesAPIKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.0];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse * __nullable response, NSData * __nullable data, NSError * __nullable connectionError)
    {
        if(!connectionError)
        {
            NSString *dta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            id collection  = [NSJSONSerialization JSONObjectWithData:[dta dataUsingEncoding:NSUTF8StringEncoding] options:
                              NSJSONReadingMutableContainers error:nil];
            
            NSArray *results = [collection objectForKey:@"results"];
            NSMutableArray *citiesArray = [[NSMutableArray alloc] init];
            for(int i = 0;i < [results count]; i++)
            {
                ELCity *city = [[ELCity alloc] init];
                [city setInfo:[results objectAtIndex:i]];
                [citiesArray addObject:city];
            }
            completion(citiesArray, nil);
        }
        else
        {
            completion(nil, connectionError);
        }
        
    }];
    
}
@end
