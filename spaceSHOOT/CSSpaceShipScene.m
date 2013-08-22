//
//  CSSpaceShipScene.m
//  spaceSHOOT
//
//  Created by Shawn Campbell on 8/18/13.
//  Copyright (c) 2013 Shawn Campbell. All rights reserved.
//

#import "CSSpaceShipScene.h"

@interface CSSpaceShipScene ()
@property BOOL contentCreated;
@end


@implementation CSSpaceShipScene
static const uint32_t missileCategory     =  0x1 << 0;
static const uint32_t shipCategory        =  0x1 << 1;
static const uint32_t asteroidCategory    =  0x1 << 2;
static const uint32_t planetCategory      =  0x1 << 3;
-(id)initWithSize: (CGSize)size {
    if (self = [super initWithSize:size]) {
        
    }
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKSpriteNode *spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame),                              CGRectGetMidY(self.frame)-150);
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.25 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
    [self addChild:spaceship];
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithImageNamed:@"rock"];
    rock.size = CGSizeMake(skRand(12,36), skRand(12, 36));
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}


- (SKSpriteNode *)newSpaceship
{
    //SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64,32)];
    SKSpriteNode *hull = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    hull.size = CGSizeMake(128, 64);
    hull.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:hull.size.width/2];
    hull.physicsBody.dynamic = NO;
    hull.physicsBody.categoryBitMask = shipCategory;
    hull.physicsBody.collisionBitMask = shipCategory | asteroidCategory | planetCategory;
    hull.physicsBody.contactTestBitMask = shipCategory | asteroidCategory | planetCategory;
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:0.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100.0 y:0 duration:1.0]]];
    [hull runAction: [SKAction repeatActionForever:hover]];
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    return hull;
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}
@end
