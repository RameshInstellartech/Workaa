//
//  CardView.h
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardsSwipingView.h"

@protocol callingdetailpageDelegate <NSObject>

-(void)callDetailPage:(NSDictionary *)dictionary;

@end

@interface CardView : UIView <SwipableCard>

@property (nonatomic, weak) id <callingdetailpageDelegate>delegate;
@property (nonatomic, retain) NSDictionary *queueDictionary;
@property (nonatomic, retain) NSString *filepath;


@end
