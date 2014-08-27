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
        NSUserDefaults * nsDefaults = [NSUserDefaults standardUserDefaults];
        self.topScore = (int)[nsDefaults integerForKey:@"topScore"];
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
-(void)setTopScore:(int)topScore
{
    _topScore = topScore;
    NSUserDefaults * nsDefaults = [NSUserDefaults standardUserDefaults];
    [nsDefaults setInteger:topScore forKey:@"topScore"];
    [nsDefaults synchronize];
}
-(NSDictionary *) levelInfo
{
    return levels[self.currentLevel];
}

@end
