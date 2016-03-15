//
//  SelectionView.h
//  comic-books
//
//  Created by Hiroshi on 3/14/16.
//  Copyright © 2016 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SELECTION_TYPE)
{
    ST_FRAME = 0,
    ST_SPEECH_BUBBLE = 1,
    ST_STAMP = 2,
    ST_FILTER = 3,
};

typedef NS_ENUM(NSUInteger, TYPE_FRAME)
{
    TF_FRAME1 = 1,
    TF_FRAME2 = 2,
    TF_FRAME3 = 3,
    TF_FRAME4 = 4,
    TF_FRAME5 = 5,
    TF_FRAME6 = 6,
    TF_FRAME7 = 7,
    TF_FRAME8 = 8,
    TF_FRAME9 = 9,
};

typedef NS_ENUM(NSUInteger, TYPE_SPEECH_BUBBLE)
{
    TSB_BUBBLE1 = 1,
};

typedef NS_ENUM(NSUInteger, TYPE_STYLE_FILTER)
{
    TSF_FILTER1 = 1,
};

@protocol SelectionViewDelegate <NSObject>

@optional

- (void) didTouchFrame:(TYPE_FRAME)typeFrame;
- (void) didTouchStamp:(char)codeStamp;
- (void) didTouchSpeechBubble:(TYPE_SPEECH_BUBBLE)typeBubble;
- (void) didTouchFilter:(TYPE_STYLE_FILTER)typeFilter;

@end

@interface SelectionView : UIScrollView

@property (nonatomic, weak) id<SelectionViewDelegate> selectionDelegate;
@property (nonatomic, readonly) SELECTION_TYPE type;

- (instancetype) initWithType:(SELECTION_TYPE)type andFrame:(CGRect)frame;

@end