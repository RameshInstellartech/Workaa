//
//  CardView.m
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

#import "CardView.h"
#import "CardsSwipingView.h"
#import "AsyncImageView.h"

static const NSUInteger kCornerRadius = 20.0f;

@implementation CardView
{
    UIView* _innerClippedView;
    UIView* _topMatterView;
}

@synthesize delegate;
@synthesize queueDictionary,filepath;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _innerClippedView = [[UIView alloc] initWithFrame:self.frame];
    _innerClippedView.layer.cornerRadius = kCornerRadius;
    _innerClippedView.layer.masksToBounds = YES;
    [self addSubview:_innerClippedView];
    
    _topMatterView = [[UIView alloc] init];
    _topMatterView.clipsToBounds = YES;
    _topMatterView.backgroundColor = [UIColor whiteColor];
    [_innerClippedView addSubview:_topMatterView];
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"queueDictionary = %@",queueDictionary);
    
    NSString *assignString = [NSString stringWithFormat:@"%@",[queueDictionary valueForKey:@"assign"]];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat userViewHeight = h*1.0;
    
    _topMatterView.frame = CGRectMake(0, 0, w, userViewHeight);
    
    /*-----------------------------------------------------*/
    
    UIView *nameView = [[UIView alloc] init];
    nameView.backgroundColor = [UIColor clearColor];
    nameView.frame = CGRectMake((_topMatterView.frame.size.width-130.0)/2.0, 15.0, 130.0, 30.0);
    nameView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    nameView.layer.borderWidth = 0.5f;
    nameView.layer.cornerRadius = nameView.frame.size.height/2.0;
    nameView.layer.masksToBounds = YES;
    [_topMatterView addSubview:nameView];
    
    NSString *imagestring = [NSString stringWithFormat:@"%@%@",filepath,[queueDictionary valueForKey:@"userPic"]];
    
    AsyncImageView *profileImage = [[AsyncImageView alloc] init];
    profileImage.frame = CGRectMake(3.5, 3.5, 23.0, 23.0);
    profileImage.layer.cornerRadius = profileImage.frame.size.height/2.0;
    profileImage.layer.masksToBounds = YES;
    profileImage.backgroundColor = [UIColor clearColor];
    profileImage.imageURL = [NSURL URLWithString:imagestring];
    profileImage.contentMode = UIViewContentModeScaleAspectFill;
    profileImage.clipsToBounds = YES;
    [nameView addSubview:profileImage];
    
//    NSString *namestring = [NSString stringWithFormat:@"%@ %@",[queueDictionary valueForKey:@"firstName"],[queueDictionary valueForKey:@"lastName"]];
    NSString *namestring = [NSString stringWithFormat:@"%@",[queueDictionary valueForKey:@"firstName"]];

    UILabel *namelbl = [[UILabel alloc] init];
    namelbl.text = namestring;
    namelbl.font = [UIFont fontWithName:@"Lato-Regular" size:13.5];
//    namelbl.frame = CGRectMake(CGRectGetMaxX(profileImage.frame)+8.0, 0.0, (nameView.frame.size.width-(CGRectGetMaxX(profileImage.frame)+5.0))-5, nameView.frame.size.height);
    CGFloat width = [self widthOfString:namestring withFont:namelbl.font];
    namelbl.frame = CGRectMake(CGRectGetMaxX(profileImage.frame)+8.0, 0.0, width, nameView.frame.size.height-2.0);
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor blackColor];
    [nameView addSubview:namelbl];
    
    nameView.frame = CGRectMake((_topMatterView.frame.size.width-(CGRectGetMaxX(namelbl.frame)+11.0))/2.0, 15.0, CGRectGetMaxX(namelbl.frame)+11.0, 30.0);

    /*-----------------------------------------------------*/
    
    CGFloat descYpos = CGRectGetMaxY(nameView.frame)+15.0;

    NSString *prioritystring = [NSString stringWithFormat:@"%@",[queueDictionary valueForKey:@"priority"]];
    if([prioritystring isEqualToString:@"1"])
    {
        UIView *priorityView = [[UIView alloc] init];
        priorityView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:57.0/255.0 blue:61.0/255.0 alpha:1.0];
        priorityView.frame = CGRectMake((_topMatterView.frame.size.width-60.0)/2.0, CGRectGetMaxY(nameView.frame)+8.0, 60.0, 15.0);
        priorityView.layer.cornerRadius = priorityView.frame.size.height/2.0;
        priorityView.layer.masksToBounds = YES;
        [_topMatterView addSubview:priorityView];
        
        UIImageView *starImage = [[UIImageView alloc] init];
        starImage.frame = CGRectMake(5.0, 2.5, 10.0, 10.0);
        starImage.backgroundColor = [UIColor clearColor];
        starImage.image = [UIImage imageNamed:@"yellowstar.png"];
        [priorityView addSubview:starImage];
        
        UILabel *prioritylbl = [[UILabel alloc] init];
        prioritylbl.frame = CGRectMake(CGRectGetMaxX(starImage.frame)+5.0, 0.0, (priorityView.frame.size.width-(CGRectGetMaxX(starImage.frame)+5.0))-5, priorityView.frame.size.height);
        prioritylbl.font = [UIFont fontWithName:@"Lato-Italic" size:10.0];
        prioritylbl.backgroundColor = [UIColor clearColor];
        prioritylbl.textColor = [UIColor whiteColor];
        prioritylbl.text = @"Priority";
        [priorityView addSubview:prioritylbl];
        
        descYpos = CGRectGetMaxY(priorityView.frame)+15.0;
    }
    
    /*-----------------------------------------------------*/
    
    NSString *datestring = [NSString stringWithFormat:@"%@",[queueDictionary valueForKey:@"time"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *date  = [dateFormatter dateFromString:datestring];
    
    // Convert to new Date Format
    NSDateFormatter *outputdateFormatter = [[NSDateFormatter alloc] init];
    outputdateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *newDate = [outputdateFormatter stringFromDate:date];
    
    UILabel *datelbl = [[UILabel alloc] init];
    datelbl.frame = CGRectMake(_topMatterView.frame.size.width-55.0, 20.0, 45.0, 21.0);
    datelbl.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
    datelbl.backgroundColor = [UIColor clearColor];
    datelbl.textColor = [UIColor lightGrayColor];
    datelbl.text = newDate;
    datelbl.textAlignment = NSTextAlignmentRight;
    datelbl.adjustsFontSizeToFitWidth = YES;
    [_topMatterView addSubview:datelbl];
    
    UILabel *dateiconlbl = [[UILabel alloc] init];
    dateiconlbl.frame = CGRectMake(datelbl.frame.origin.x-16.0, 21.0, 15.0, 21.0);
    dateiconlbl.font = [UIFont fontWithName:@"icomoon" size:14.0];
    dateiconlbl.backgroundColor = [UIColor clearColor];
    dateiconlbl.textColor = [UIColor lightGrayColor];
    dateiconlbl.text = @"\ue91a";
    [_topMatterView addSubview:dateiconlbl];
    
    /*-----------------------------------------------------*/
    
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    btnView.frame = CGRectMake(0.0, _topMatterView.frame.size.height-60.0, _topMatterView.frame.size.width, 60.0);
    [_topMatterView addSubview:btnView];
    
    CGFloat btnwidth = (btnView.frame.size.width-75.0)/2.0;
    NSLog(@"btnwidth = %f",btnwidth);
    
    UIButton *laterbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    laterbutton.frame = CGRectMake(25.0, (btnView.frame.size.height-30.0)/2.0, btnwidth, 30.0);
    laterbutton.backgroundColor = [UIColor redColor];
    [laterbutton setTitle:@"Later" forState:UIControlStateNormal];
    [laterbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    laterbutton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    laterbutton.layer.cornerRadius = laterbutton.frame.size.height/2.0;
    laterbutton.layer.masksToBounds = YES;
    [laterbutton addTarget:self.superview action:@selector(dismissTopCardToLeft) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:laterbutton];
    
    UIButton *taskbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    taskbutton.frame = CGRectMake(CGRectGetMaxX(laterbutton.frame)+25.0, (btnView.frame.size.height-30.0)/2.0, btnwidth, 30.0);
    taskbutton.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:208.0/255.0 blue:124.0/255.0 alpha:1.0];
//    [taskbutton setTitle:@"Assign Task" forState:UIControlStateNormal];
    [taskbutton setTitle:@"Edit & Assign" forState:UIControlStateNormal];
    [taskbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    taskbutton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    taskbutton.layer.cornerRadius = taskbutton.frame.size.height/2.0;
    taskbutton.layer.masksToBounds = YES;
    [taskbutton addTarget:self action:@selector(expandaction) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:taskbutton];
    
    if([assignString isEqualToString:@"0"])
    {
        btnView.hidden = YES;
    }
    else
    {
        btnView.hidden = NO;
    }
    
    /*-----------------------------------------------------*/
    
    UIView *groupnameView = [[UIView alloc] init];
    groupnameView.backgroundColor = [UIColor clearColor];
    groupnameView.frame = CGRectMake(0.0, btnView.frame.origin.y-35.0, _topMatterView.frame.size.width, 20.0);
    [_topMatterView addSubview:groupnameView];
    
    NSString *groupimagestring = [NSString stringWithFormat:@"%@%@",filepath,[queueDictionary valueForKey:@"groupLogo"]];
    
    AsyncImageView *groupImage = [[AsyncImageView alloc] init];
    groupImage.frame = CGRectMake(0.0, 0.0, groupnameView.frame.size.height, groupnameView.frame.size.height);
    groupImage.layer.cornerRadius = groupImage.frame.size.height/2.0;
    groupImage.layer.masksToBounds = YES;
    groupImage.backgroundColor = [UIColor clearColor];
    groupImage.imageURL = [NSURL URLWithString:groupimagestring];
    groupImage.contentMode = UIViewContentModeScaleAspectFill;
    profileImage.clipsToBounds = YES;
    [groupnameView addSubview:groupImage];
    
    NSString *groupnamestring = [NSString stringWithFormat:@"%@",[queueDictionary valueForKey:@"groupName"]];
    
    UILabel *titlelbl = [[UILabel alloc] init];
    titlelbl.text = groupnamestring;
//    titlelbl.frame = CGRectMake(CGRectGetMaxX(groupImage.frame)+5.0, 0.0, (groupnameView.frame.size.width-(CGRectGetMaxX(groupImage.frame)+5.0))-5, groupnameView.frame.size.height);
    titlelbl.frame = CGRectMake(CGRectGetMaxX(groupImage.frame)+5.0, 0.0, titlelbl.intrinsicContentSize.width, groupnameView.frame.size.height);
    titlelbl.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    titlelbl.backgroundColor = [UIColor clearColor];
    titlelbl.textColor = [UIColor lightGrayColor];
    [groupnameView addSubview:titlelbl];
    
    CGFloat groupwidth = titlelbl.intrinsicContentSize.width + 35.0;
    groupnameView.frame = CGRectMake((_topMatterView.frame.size.width-groupwidth)/2.0, btnView.frame.origin.y-35.0, groupwidth, 20.0);
    
    /*-----------------------------------------------------*/
    
    NSString *taskstring = [NSString stringWithFormat:@"%@",[queueDictionary valueForKey:@"task"]];
    
    CGFloat descheight = (groupnameView.frame.origin.y-descYpos)-10.0;
    
    UILabel *desclbl = [[UILabel alloc] init];
    desclbl.frame = CGRectMake(5.0, descYpos, _topMatterView.frame.size.width-10.0, descheight);
    desclbl.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
    desclbl.backgroundColor = [UIColor clearColor];
    desclbl.textColor = [UIColor blackColor];
    desclbl.text = taskstring;
    desclbl.textAlignment = NSTextAlignmentCenter;
    desclbl.numberOfLines = 100;
    [_topMatterView addSubview:desclbl];
    
    /*-----------------------------------------------------*/
    
    UIButton *overlaybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    overlaybutton.frame = CGRectMake(0.0, 0.0, _topMatterView.frame.size.width, _topMatterView.frame.size.height-btnView.frame.size.height);
    overlaybutton.backgroundColor = [UIColor clearColor];
    [overlaybutton addTarget:self action:@selector(expandaction) forControlEvents:UIControlEventTouchUpInside];
    [_topMatterView addSubview:overlaybutton];
}

-(void)expandaction
{
    [self.delegate callDetailPage:queueDictionary];
    
//    _topMatterView.frame = CGRectMake(0.0, ([[UIScreen mainScreen] bounds].size.height-_topMatterView.frame.size.height)/2.0, [[UIScreen mainScreen] bounds].size.width, _topMatterView.frame.size.height);
//    _topMatterView.alpha = 0.0;
//    [self.superview.superview.superview addSubview:_topMatterView];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        _topMatterView.alpha = 1.0;
//        _topMatterView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//    } completion:^(BOOL finished) {
//    }];
}

#pragma mark - SwipableCard

- (void)prepareToBecomeTopCard {
    _topMatterView.alpha = 1.0f;
}

- (void)prepareToBecomeBackgroundCard {
    _topMatterView.alpha = 0.25f;
}

@end
