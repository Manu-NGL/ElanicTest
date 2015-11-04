//
//  ELSpa.m
//  ElanicTest
//
//  Created by Manohar T on 01/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ELSpa.h"

@implementation ELSpa

@synthesize title = _title;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _title = @"Spa";
    }
    return self;
}


@end
