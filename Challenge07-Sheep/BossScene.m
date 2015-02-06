//
//  BossScene.m
//  Challenge07-Sheep
//
//  Created by Rodrigo Dezouzart on 2/4/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "BossScene.h"

@implementation BossScene

bool playing;

SKLabelNode *coinsLabel;
SKLabelNode *msgLabel;
SKLabelNode *scoreLabel;
SKLabelNode *heartLabel;

SKSpriteNode *coinsImg;
SKSpriteNode *heartImg;
SKSpriteNode *bgImage;

SKAction *msgAct;

-(void) didMoveToView:(SKView *)view {
    
    playing = true;

    msgAct = [SKAction sequence:@[
                                      [SKAction fadeAlphaTo:1 duration:3],
                                      [SKAction waitForDuration:1],
                                      [SKAction fadeOutWithDuration:2]
                                      ]];
    
    [self createBackground];
    
    [self playEffectBgSounds];
    
    [msgLabel runAction: msgAct];
    
}

-(void) createBackground {
    
    bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundBoss.png"];
    bgImage.size = CGSizeMake(self.frame.size.width, self.frame.size.height/2-100);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    bgImage.zPosition = 0;
    [self addChild:bgImage];
    
    msgLabel= [SKLabelNode labelNodeWithFontNamed:@"HoeflerText-BlackItalic"];
    msgLabel.fontSize = 25;
    msgLabel.fontColor = [SKColor blackColor];
    msgLabel.position = CGPointMake((self.frame.size.width/2), (self.frame.size.height/2+45));
    msgLabel.text = @"Fire Waves";
    msgLabel.zPosition = 1;
    msgLabel.alpha = 0;
    [self addChild:msgLabel];
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 15;
    scoreLabel.position = CGPointMake((self.frame.size.width/8), (self.frame.size.height/2.8));
    scoreLabel.text = [NSString stringWithFormat:@"%.0f", _scoreParam];
    scoreLabel.zPosition = 1;
    [self addChild:scoreLabel];
    
    coinsLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coinsLabel.fontSize = 12;
    coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame)-105, CGRectGetMidY(self.frame)+45);
    coinsLabel.fontColor = [SKColor whiteColor];
    coinsLabel.text = [NSString stringWithFormat:@"%.0f", _coinsParam];
    coinsLabel.zPosition = 1;
    [self addChild:coinsLabel];
    
    coinsImg = [SKSpriteNode spriteNodeWithImageNamed:@"coins.png"];
    coinsImg.xScale = 0.05;
    coinsImg.yScale = 0.05;
    coinsImg.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)+52);
    coinsImg.zPosition = 1;
    [self addChild:coinsImg];
    
    heartImg = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    heartImg.xScale = 0.01;
    heartImg.yScale = 0.01;
    heartImg.position = CGPointMake(CGRectGetMidX(self.frame)-129, CGRectGetMidY(self.frame)+72);
    heartImg.zPosition = 1;
    [self addChild:heartImg];
    
    heartLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    heartLabel.fontSize = 15;
    heartLabel.text = [NSString stringWithFormat:@"%d", _nHeartsParam];
    heartLabel.position = CGPointMake(CGRectGetMidX(self.frame)-103, CGRectGetMidY(self.frame)+63);
    heartLabel.fontColor = [SKColor whiteColor];
    heartLabel.zPosition = 1;
    [self addChild:heartLabel];
    
    [self showHighScore];
    
    
    [_spriteParam removeFromParent];
    [self addChild:_spriteParam];

}

-(void)playEffectBgSounds{
    
    //Play Sound
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"backgroundMusic"
                                         ofType:@"wav"]];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.numberOfLoops = -1;
    
    [_player play];
}

-(void) showHighScore {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+70);
    highScoreTitle.text = @"High Score";
    highScoreTitle.zPosition = 1;
    [self addChild:highScoreTitle];
    
    
    SKLabelNode *highScore;
    highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.fontSize = 10;
    highScore.fontColor = [SKColor redColor];
    highScore.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+60);
    highScore.text = [NSMutableString stringWithFormat:@"%.0f", _rankingParam];
    highScore.zPosition  =1;
    [self addChild:highScore];
    
}

-(void)update:(NSTimeInterval)currentTime {
    if(playing){
        _scoreParam += 0.1;
        scoreLabel.text = [NSString stringWithFormat:@"%.0f", _scoreParam];
        
        _coinsParam += 0.005;
        coinsLabel.text = [NSString stringWithFormat:@"%.0f", _coinsParam];
        
        if ( _scoreParam >= _rankingParam )
            scoreLabel.fontColor = [SKColor redColor];
    }
    
}


@end
