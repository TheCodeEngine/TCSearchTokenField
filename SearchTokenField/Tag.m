//
//  Tag.m
//  SearchTokenField
//
//  Created by Konstantin Stoldt on 09.08.13.
//  Copyright (c) 2013 TheCodeEngine. All rights reserved.
//

#import "Tag.h"

@implementation Tag

- (id)initWithTitle:(NSString *)title
{
    if ( self = [super init] )
    {
        _title = title;
    }
    return self;
}

@end
