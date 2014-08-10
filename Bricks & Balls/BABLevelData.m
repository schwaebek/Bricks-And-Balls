//
//  BABLevelData.m
//  Bricks & Balls
//
//  Created by Katlyn Schwaebe on 8/7/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "BABLevelData.h"

@implementation BABLevelData
{
    NSArray * levels;
    
}

+ (BABLevelData *) mainData
{
    static dispatch_once_t create;
    static BABLevelData * singleton = nil;
    
    dispatch_once(&create, ^{
        
        singleton = [[BABLevelData alloc] init];
        
        
    });
    return singleton;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        levels = @[
                   @{
                       @"cols": @6,
                       @"rows": @3
                       },
                   @{
                       @"cols": @7,
                       @"rows": @4
                       },
                   @{
                       @"cols": @10,
                       @"rows": @4
                       },
                   ];
    }
    return self;
}

-(NSDictionary *) levelInfo
{
    return levels[self.currentLevel];
}

@end
