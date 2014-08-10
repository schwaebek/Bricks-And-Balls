//
//  BABGameBoardViewController.m
//  Bricks & Balls
//
//  Created by Katlyn Schwaebe on 8/6/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "BABGameBoardViewController.h"
#import "BABHeaderView.h"
#import "BABLevelData.h"
// when gameover clear bricks and show start button
// create new class called "BABlevelData" as a subclass of NSObject
// make a method that will drop a UIView (gravity) from a broken brick like a powerup
//listen for it to collide with paddle
//randomly change size of paddle when powerup hit paddle



// create 5 different types of power ups (paddle size big, paddle size small, multi ball, ball size big, ball size small) - the power ups should look different
// set topScore for your singleton
// change the look of your game with images or colors (**make it unique to you**)
// if game over set currentLevel to 0




@interface BABGameBoardViewController () <UICollisionBehaviorDelegate,UIAlertViewDelegate>

@end

@implementation BABGameBoardViewController
{
    UIDynamicAnimator * animator;
    UIDynamicItemBehavior * ballItemBehavior;
    UIDynamicItemBehavior * brickItemBehavior;
    UIGravityBehavior * gravityBehavior;
    UICollisionBehavior * collisionBehavior;
    UIAttachmentBehavior * attachmentBehavior;
    UICollisionBehavior * collisionPower;
    
    NSMutableArray * bricks;
    UILabel * scoreLabel;
    UIView * ball;
    UIView * paddle;
    
    UILabel * livesLabel;
    UIButton * startButton;
    UIButton * resetButton;
    UIView * powerUp;
    UIView * powerUpMulti;
    //    UIView * brick;
    // int lives;
    // int score;
    
    
    BABHeaderView * headerView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        bricks =[@[] mutableCopy];
        
        headerView = [[BABHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        [self.view addSubview:headerView];
        
        
        animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        ballItemBehavior = [[UIDynamicItemBehavior alloc] init];
        ballItemBehavior.friction = 0;
        ballItemBehavior.elasticity = 1.0;
        ballItemBehavior.resistance = 0;
        ballItemBehavior.allowsRotation = NO;
        [animator addBehavior:ballItemBehavior];
        
        gravityBehavior = [[UIGravityBehavior alloc] init];
        [animator addBehavior:gravityBehavior];
        
        collisionBehavior = [[UICollisionBehavior alloc]init];
        [collisionBehavior addBoundaryWithIdentifier:@"floor" fromPoint:CGPointMake(0, SCREEN_HEIGHT + 20) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        [collisionBehavior addBoundaryWithIdentifier:@"left wall" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, SCREEN_HEIGHT)];
        [collisionBehavior addBoundaryWithIdentifier:@"right wall" fromPoint:CGPointMake(SCREEN_WIDTH, 0) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        [collisionBehavior addBoundaryWithIdentifier:@"ceiling" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(SCREEN_WIDTH, 0)];
        collisionBehavior.collisionDelegate = self;
        [animator addBehavior:collisionBehavior];
        
        brickItemBehavior = [[UIDynamicItemBehavior alloc]init];
        brickItemBehavior.density = 1000000;
        [animator addBehavior:brickItemBehavior];
        
        collisionPower = [[UICollisionBehavior alloc]init];
        
        
        // Custom initialization
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    paddle = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) /2.0, SCREEN_HEIGHT - 10, 100, 4)];
    paddle.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:paddle];
    
    
    [self showStartButton];
    
    
    resetButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -100) /2.0,(SCREEN_HEIGHT -100) /2.0, 100, 100)];
    [resetButton setTitle: @"START" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetGame) forControlEvents:UIControlEventTouchUpInside];
    resetButton.backgroundColor = [UIColor grayColor];
    resetButton.layer.cornerRadius = 50;
    //[self.view addSubview:resetButton];
    
}

-(void)powerUpWithBrick:(UIView *)brick
{
    // position power up and activate when brick breaks
    // create powerUp
    // refer to reset bricks method and gravity behavior
    
    powerUp = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 25, 25)];
    collisionPower.collisionDelegate= self;
    powerUp.layer.cornerRadius = 12.5;
    powerUp.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:powerUp];
    
    [gravityBehavior addItem:powerUp];
    [collisionPower addItem:powerUp];
    [collisionPower addItem:paddle];
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionPower];
    
    
    
    
}
-(void)powerUpMultiBall:(UIView *)brick
{
    // position power up and activate when brick breaks
    // create powerUp
    // refer to reset bricks method and gravity behavior
    
    powerUpMulti = [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y, 40, 40)];
    collisionPower.collisionDelegate= self;
    powerUpMulti.layer.cornerRadius = 20.0;
    powerUpMulti.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:powerUpMulti];
    
    [gravityBehavior addItem:powerUpMulti];
    [collisionPower addItem:powerUpMulti];
    [collisionPower addItem:paddle];
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionPower];

}
-(void)resetGame
{
    [resetButton removeFromSuperview];
    [self resetBricks];
    [self createBall];
    
}

-(void)startGame
{
    [startButton removeFromSuperview];
    [self resetBricks];
    [self createBall];
    headerView.lives = 3;
    headerView.score = 0;
    
    
}

-(void)resetBricks
{
    for (UIView * brick in bricks)
    {
        [brick removeFromSuperview];
        [brickItemBehavior removeItem:brick];
        [collisionBehavior removeItem:brick];
    }
    [bricks removeAllObjects];
    
    int colCount = [[[BABLevelData mainData] levelInfo][@"cols"] intValue];
    int rowCount = [[[BABLevelData mainData] levelInfo][@"rows"] intValue];
    int brickSpacing = 8;
    
    for (int col = 0; col < colCount; col++)
    {
        for (int row = 0; row< rowCount; row++)
        {
            float width = (SCREEN_WIDTH - (brickSpacing * colCount +1)) /colCount;
            float height = ((SCREEN_HEIGHT / 3) - (brickSpacing * rowCount)) / rowCount;
            
            float x = brickSpacing + (width + brickSpacing) * col;
            float y = brickSpacing + (height + brickSpacing) * row +30;
            UIView * brick = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            
            CGFloat hue = (arc4random() % 256 / 256.0);
            CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
            CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
            
            NSLog(@"%f %f %f",hue,saturation,brightness);
            
            UIColor * brickColor =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            brick.backgroundColor = brickColor;
            
            [self.view addSubview:brick];
            [bricks addObject:brick];
            
            [collisionBehavior addItem:brick];
            [brickItemBehavior addItem:brick];
            
        }
    }
    
//}
//
//-(void)createCollisionMethod
//{
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:paddle attachedToAnchor: paddle.center];
    [animator addBehavior:attachmentBehavior];
    
    [collisionBehavior addItem:paddle];
    [brickItemBehavior addItem:paddle];
    
    //    [self createBall];
    //    [self resetBricks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if ([@"floor" isEqualToString:(NSString *)identifier])
    {
        UIView * ballItem = (UIView *)item;
        [collisionBehavior removeItem:ballItem];
        headerView.lives--;
        
        [ballItem removeFromSuperview];
        ball = nil;
        
        if (headerView.lives > 0)
        {
            [self createBall];
        } else {
            
            // need to call show start button
            
            [self showStartButton];
            
        }
    }
}

// create show start button method

// remove all bricks

// create the start button
-(void)showStartButton
{
    for (UIView * brick in bricks)
    {
        [brick removeFromSuperview];
        [brickItemBehavior removeItem:brick];
        [collisionBehavior removeItem:brick];
    }
    [bricks removeAllObjects];
    
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -100) /2.0,(SCREEN_HEIGHT -100) /2.0, 100, 100)];
    [startButton setTitle: @"START" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    startButton.backgroundColor = [UIColor grayColor];
    startButton.layer.cornerRadius = 50;
    [self.view addSubview:startButton];
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    if (headerView.lives == 0)
    {
        [self createBall];
        
        headerView.lives = 3;
        headerView.score = 0;
        
        [self resetBricks];
        
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item1 isEqual:powerUp] || [item2 isEqual:powerUp])
    {
        [collisionPower removeItem:powerUp];
        [powerUp removeFromSuperview];
        powerUp = nil;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            powerUp.alpha = 0;
        } completion:^(BOOL finished) {
            [powerUp removeFromSuperview];
        }];
        
        if (powerUp == nil)
        {
            CGRect frame = paddle.frame;
            frame.size.width = arc4random_uniform(100) + 100;// play around with paddle sizez
            //paddle.backgroundColor = [UIColor grayColor];
            paddle.frame = frame;
            
        };
        
        return;
    }

    
    for (UIView * brick in [bricks copy])
    {
        if ([item1 isEqual:brick] || [item2 isEqual:brick])
        {
            headerView.score +=100;
            
            int random = arc4random_uniform(3);
            if (random == 3)
            {
                [self powerUpWithBrick:brick];
            }
            
            
            [collisionBehavior removeItem:brick];
            scoreLabel.text = [NSString stringWithFormat:@"Score %d", headerView.score];
            [gravityBehavior addItem:brick];
            [bricks removeObjectIdenticalTo:brick];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                brick.alpha = 0;
            }completion:^(BOOL finished) {
                [brick removeFromSuperview];
                [bricks removeObjectIdenticalTo:brick];
            }];
            
            if(bricks.count == 0)
            {
                [collisionBehavior removeItem:ball];
                [ball removeFromSuperview];
                
                [BABLevelData mainData].currentLevel++;
                [self showStartButton];
            }
            
        }
    }
}

-(void)createBall
{
    ball = [[UIView alloc] initWithFrame:CGRectMake(paddle.center.x, SCREEN_HEIGHT - 50, 20, 20)];
    ball.layer.cornerRadius = ball.frame.size.width/ 2.0;
    ball.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:ball];
    
    [collisionBehavior addItem:ball];
    [ballItemBehavior addItem:ball];
    
    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(0.05, -0.05);
    [animator addBehavior:pushBehavior];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self movePaddleWithTouches:touches];
}
-(void)movePaddleWithTouches:(NSSet *) touches
{
    UITouch * touch = [touches allObjects][0];
    CGPoint location = [touch locationInView:self.view];
    
    float guard = paddle.frame.size.width / 2.0 + 10;
    float dragX = location.x;
    
    if(dragX < guard) dragX = guard;
    if(dragX > SCREEN_WIDTH - guard) dragX = SCREEN_WIDTH - guard;
    attachmentBehavior.anchorPoint = CGPointMake(location.x, paddle.center.y);
    
    
    //paddle.center = CGPointMake(location.x, paddle.center.y);
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
