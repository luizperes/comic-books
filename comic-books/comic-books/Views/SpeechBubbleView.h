//
//  SpeechBubbleView.h
//  comic-books
//
//  Created by CICCC1 on 2016-03-10.
//  Copyright © 2016 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeechBubbleView : UIView

- (instancetype)initWithCode:(char)codeStamp andParent:(UIView *)parentView;

- (void) handlePinch:(UIPinchGestureRecognizer *)pinchGesture;
- (void) handleRotation:(UIRotationGestureRecognizer *)rotationGesture;
- (void) handlePan:(UIPanGestureRecognizer *)panGesture;

@end
