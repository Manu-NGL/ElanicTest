//
//  ELSchool.m
//  ElanicTest
//
//  Created by Manohar T on 01/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ELSchool.h"

@implementation ELSchool

@synthesize title = _title;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _title = @"School";
    }
    return self;
}


@end
