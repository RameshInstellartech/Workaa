//
//  TTFadeSwitch.m
//  TTSwitch
//
//  Created by Scott Penrose on 4/19/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "TTFadeSwitch.h"
#import "TTSwitchSubclass.h"

@interface TTFadeSwitch ()

@property (nonatomic, strong) UIImageView *trackImageOnView;
@property (nonatomic, strong) UIImageView *trackImageOffView;

@end

@implementation TTFadeSwitch
@synthesize viewstring;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fadeSwitchCommonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self fadeSwitchCommonInit];
    }
    return self;
}

- (void)fadeSwitchCommonInit
{
    self.maskInLockPosition = @YES;
    
    _trackImageOnView = [[UIImageView alloc] init];
    _trackImageOffView = [[UIImageView alloc] init];

    // insert below self.trackImageView because the labels are added to it
    [self.maskedTrackView insertSubview:_trackImageOnView belowSubview:self.trackImageView];
    [self.maskedTrackView insertSubview:_trackImageOffView belowSubview:self.trackImageView];

    self.trackImage = nil;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    // Sets the labels positions correctly on track
    self.trackImageView.frame = (CGRect){
        CGPointZero,
        { self.trackMaskImage.size.width * 2.0f - self.thumbImageView.frame.size.width - self.thumbInsetX * 2.0f, self.trackMaskImage.size.height }
    };
    [self updateThumbPositionAnimated:NO];

    [super layoutSubviews];
}

#pragma mark - Public Interface

- (void)setTrackImage:(UIImage *)trackImage
{
    // always set the track image to nil and use trackImageOn and trackImageOff.
    [super setTrackImage:nil];
}

- (void)setTrackImageOn:(UIImage *)trackImageOn
{
    if (_trackImageOn != trackImageOn) {
        _trackImageOn = trackImageOn;
        [_trackImageOnView setImage:_trackImageOn];
        [_trackImageOnView setFrame:(CGRect){ CGPointZero, _trackImageOn.size }];
    }
}

- (void)setTrackImageOff:(UIImage *)trackImageOff
{
    if (_trackImageOff != trackImageOff) {
        _trackImageOff = trackImageOff;
        [_trackImageOffView setImage:_trackImageOff];
        [_trackImageOffView setFrame:(CGRect){ CGPointZero, _trackImageOff.size }];
    }
}

#pragma mark - TTSwitch

- (void)moveThumbCenterToX:(CGFloat)newThumbCenterX
{
    [super moveThumbCenterToX:newThumbCenterX];
    [self.trackImageOffView setAlpha:(self.on ? 0.0f : 1.0f)];

    if(self.on)
    {
        if([viewstring isEqualToString:@"myTask"] || [viewstring isEqualToString:@"addQueue"])
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:208.0/255.0 blue:124.0/255.0 alpha:1.0];
        }
        else if([viewstring isEqualToString:@"groupType"])
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:202.0/255.0 blue:252.0/255.0 alpha:1.0];
        }
        else
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:208.0/255.0 blue:124.0/255.0 alpha:1.0];
        }
    }
    else
    {
        if([viewstring isEqualToString:@"myTask"])
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:162.0/255.0 blue:0.0/255.0 alpha:1.0];
        }
        else if([viewstring isEqualToString:@"addQueue"])
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:57.0/255.0 blue:61.0/255.0 alpha:1.0];
        }
        else if([viewstring isEqualToString:@"groupType"])
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:208.0/255.0 blue:124.0/255.0 alpha:1.0];
        }
        else if([viewstring isEqualToString:@"hours"])
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0];
        }
        else
        {
            self.trackImageView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:202.0/255.0 blue:252.0/255.0 alpha:1.0];
        }
    }
}

- (void)didMoveThumbCenterToX:(CGFloat)newThumbCenterX
{
    // no-op
}


#pragma mark - UIGestureRecognizer

- (void)handleThumbPanGesture:(UIPanGestureRecognizer *)gesture
{
    [super handleThumbPanGesture:gesture];

    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        CGFloat minBoundary = self.thumbInsetX + (self.thumbImageView.bounds.size.width / 2.0f);
        CGFloat maxBoundary = self.bounds.size.width - (self.thumbImageView.bounds.size.width / 2.0f) - self.thumbInsetX;
        self.trackImageOffView.alpha = (1.0f - ((self.thumbImageView.center.x - minBoundary)/(maxBoundary - minBoundary)));
    }
}

@end
