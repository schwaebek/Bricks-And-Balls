//
//  BABHeaderView.m
//  Bricks & Balls
//
//  Created by Katlyn Schwaebe on 8/7/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "BABHeaderView.h"
#import "BABLevelData.h"


@implementation BABHeaderView
{
    UIView * ballHolder;
    UILabel * scoreLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        ballHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [self addSubview:ballHolder];
        
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 0, 190, 40)];
        scoreLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:scoreLabel];
        
        self.lives = 3;
        self.score = 0;
    }
    return self;
    
}

-(void) setScore:(int)score
{
    _score = score;
    if([BABLevelData mainData].topScore < score) [BABLevelData mainData].topScore = score;
    scoreLabel.text = [NSString stringWithFormat:@"Score : %d",score];
}
-(void) setLives:(int)lives
{
    _lives = lives;
    for (UIView * lifeBall in ballHolder.subviews)
    {
        [lifeBall removeFromSuperview];
    }
    for (int i = 0; i < lives; i++)
    {
        UIView * lifeBall = [[UIView alloc] initWithFrame:CGRectMake(10 + 30 * i, 10, 20, 20)];
        lifeBall.backgroundColor = [UIColor magentaColor];
        lifeBall.layer.cornerRadius = 10;
        [ballHolder addSubview:lifeBall];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
