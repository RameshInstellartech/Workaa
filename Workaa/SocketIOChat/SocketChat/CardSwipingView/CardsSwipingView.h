//
//  CardsSwipingView.h
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardsSwipingView;

@protocol SwipableCard <NSObject>
@optional
- (UIView*)viewShownOnSwipeLeft;
- (UIView*)viewShownOnSwipeRight;
- (void)prepareToBecomeTopCard;
- (void)prepareToBecomeBackgroundCard;

@end

@protocol CardsSwipingViewDelegate <NSObject>

- (BOOL)cardsSwipingView:(CardsSwipingView*)cardsSwipingView willDismissCard:(UIView*)card toLeft:(BOOL)toLeft;

@end

@interface CardsSwipingView : UIView

@property (nonatomic, weak) id<CardsSwipingViewDelegate> delegate;

- (void)enqueueCard:(UIView*)card;
- (UIView*)dismissTopCardToLeft;
- (UIView*)dismissTopCardToRight;
- (NSUInteger)numberOfCardsInQueue;
- (void)clearQueue;

@end
