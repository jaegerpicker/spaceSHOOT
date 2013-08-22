//
//  CSMyScene.m
//  spaceSHOOT
//
//  Created by Shawn Campbell on 8/18/13.
//  Copyright (c) 2013 Shawn Campbell. All rights reserved.
//

#import "CSMyScene.h"
#import "CSSpaceShipScene.h"

@implementation CSMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Space Shooter SHOOT!";
        myLabel.fontSize = 20;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        myLabel.name = @"helloNode";
        
        [self addChild:myLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }*/
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    if (helloNode != nil)
    {
        //helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 50.0 duration: 0.1];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.1];
        SKAction *pause = [SKAction waitForDuration: 0.1];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.1];
        //SKAction *remove = [SKAction removeFromParent];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.1];
        SKAction *unzoom = [SKAction scaleTo:1.0 duration:0.1];
        SKAction *moveDown = [SKAction moveByX:0 y:-50.0 duration:0.1];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, fadeIn, pause, unzoom, moveDown]];
        [helloNode runAction: moveSequence completion:^{
            SKScene *spaceshipScene  = [[CSSpaceShipScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
