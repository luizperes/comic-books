//
//  MainViewController.m
//  comic-books
//
//  Created by Hiroshi on 3/14/16.
//  Copyright © 2016 Ideia do Luiz. All rights reserved.
//

#import "MainViewController.h"
#import "Utilities.h"
#import "FrameHelper.h"
#import "ImageFilterHelper.h"
#import "StampGestureHelper.h"
#import "DialogHelper.h"
#import "SpeechBubbleView.h"
#import "FilterView.h"

@interface MainViewController ()

@property (nonatomic) UIView *mainView;
@property (nonatomic) UIView *tabView;
@property (nonatomic) NSArray<SelectionView *> *selectionArr;
@property (nonatomic) UIImage *originalChosenImage;


@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createMainView];
    [self initializeView];
}

- (void) createMainView
{
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.01,
                                                             self.view.bounds.size.height*0.09,
                                                             self.view.bounds.size.width*0.98,
                                                             self.view.bounds.size.width*0.98)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.clipsToBounds = YES;
    [self.view addSubview:self.mainView];
}

- (void) initializeView
{
    self.view.backgroundColor = [Utilities specialGrayColor];
    
    SelectionView *selectionFilter = [[SelectionView alloc] initWithType:ST_FILTER andFrame:CGRectMake(0, self.view.frame.size.height - [Utilities sizeFrame], self.view.frame.size.width, [Utilities sizeFrame])];
    selectionFilter.selectionDelegate = self;
    [self.view addSubview:selectionFilter];
    
    SelectionView *selectionFrame = [[SelectionView alloc] initWithType:ST_FRAME andFrame:CGRectMake(0, self.view.frame.size.height - [Utilities sizeFrame], self.view.frame.size.width, [Utilities sizeFrame])];
    selectionFrame.selectionDelegate = self;
    [self.view addSubview:selectionFrame];
    
    SelectionView *selectionStamp = [[SelectionView alloc] initWithType:ST_STAMP andFrame:CGRectMake(0, self.view.frame.size.height - [Utilities sizeFrame], self.view.frame.size.width, [Utilities sizeFrame])];
    [self.view addSubview:selectionStamp];
    selectionStamp.selectionDelegate = self;
    selectionStamp.hidden = YES;
    
    SelectionView *selectionSpeechBubble = [[SelectionView alloc] initWithType:ST_SPEECH_BUBBLE andFrame:CGRectMake(0, self.view.frame.size.height - [Utilities sizeFrame], self.view.frame.size.width, [Utilities sizeFrame])];
    [self.view addSubview:selectionSpeechBubble];
    selectionSpeechBubble.selectionDelegate = self;
    selectionSpeechBubble.hidden = YES;
    
    self.selectionArr = @[selectionFrame, selectionFilter, selectionStamp, selectionSpeechBubble];
    
    [self createTabBar];
    [[FrameHelper sharedInstance] createLayouts:self.mainView type:1 andViewController:self];
}

- (void) createTabBar
{
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainView.frame.origin.y + self.mainView.frame.size.height, self.view.frame.size.width, [Utilities sizeFrame])];
    [self.view addSubview:tabView];
    
    NSArray *arrayOfImages = @[@"layout_icon",  @"filter_icon", @"speech_bubble_icon", @"stamp_icon"];
    SELECTION_TYPE typeItem[4] = { ST_FRAME, ST_FILTER , ST_SPEECH_BUBBLE, ST_STAMP };
    for (int i = 0; i < [arrayOfImages count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrayOfImages[i]]];
        CGFloat size = [Utilities sizeIconWithParentSize:tabView.frame.size.width];
        imageView.frame = CGRectMake(0, 0, size, size);
        imageView.center = CGPointMake(tabView.frame.size.width / [arrayOfImages count] * i + (tabView.frame.size.width / [arrayOfImages count] / 2), tabView.frame.size.height / 2);
        imageView.tag = typeItem[i];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabTap:)];
        [imageView addGestureRecognizer:tap];
        [tabView addSubview:imageView];
    }
}

- (void) handleTabTap:(UITapGestureRecognizer *)tapGesture
{
    __block NSUInteger tag = tapGesture.view.tag;
    [self.selectionArr enumerateObjectsUsingBlock:^(SelectionView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (tag != ((SelectionView *)obj).type)
            obj.hidden = YES;
        else
            obj.hidden = NO;
    }];
}

- (void) clearChildrenMainView
{
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [obj removeFromSuperview];
     }];
}

- (void) dismissDialogView
{
    [self.dialogView removeFromSuperview];
}

- (void)makeLayoutWithFrame:(CGRect)frame parent:(UIView *)parent andTag:(NSInteger)tag
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
    image.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    [parent addSubview:image];
    image.tag = -tag;
    
    UILabel *plusLabel = [[UILabel alloc]init];
    plusLabel.text = @"+";
    plusLabel.tag = tag;
    plusLabel.font=[UIFont fontWithName:@"Helvetica" size:50];
    plusLabel.textAlignment = NSTextAlignmentCenter;
    [plusLabel sizeToFit];
    plusLabel.textColor = [UIColor lightGrayColor];
    plusLabel.center = image.center;
    
    plusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plusTap:)];
    [plusLabel addGestureRecognizer:tapGesture];
    
    [parent addSubview:plusLabel];
}


- (void)didTouchFrame:(TYPE_FRAME)typeFrame
{
    [[FrameHelper sharedInstance] createLayouts:self.mainView type:typeFrame andViewController:self];
}

- (void)didTouchFilter:(TYPE_STYLE_FILTER)typeFilter
{
    UIImageView *imageView = (UIImageView*)[self.mainView viewWithTag:self.imgFlag];
    imageView.image = [FilterView imageFilterWithParent:self.mainView type:typeFilter andOriginalImage:self.originalChosenImage];
}

- (void)plusTap:(UITapGestureRecognizer*)tapGestureRecognizer
{
    //[self handlePlusTapWithTag:tapGestureRecognizer.view.tag];
    [[DialogHelper sharedInstance] handlePlusTapWithTag:tapGestureRecognizer.view.tag andViewController:self];

}

- (void)createPopupImageWithSize:(CGRect)size imageName:(NSString*)name target:(id)target andFunction:(nonnull SEL)function
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:size];
    [imageView setImage:[UIImage imageNamed:name]];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:target action:function];
    [imageView addGestureRecognizer:tap];
    [self.dialogView addSubview:imageView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissDialogView];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.originalChosenImage = info[UIImagePickerControllerEditedImage];
    UIImageView *imageView = (UIImageView*)[self.mainView viewWithTag:self.imgFlag];
    
    
    
    
    
    // customize images
    UIImage *editedImage = [[ImageFilterHelper sharedInstance] CMYKHalftoneImageWithImage:self.originalChosenImage andCenter:[CIVector vectorWithX:imageView.frame.size.width/2 Y:imageView.frame.size.height/2]];
    
    
    
    
    
    imageView.image = editedImage;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
}

- (void)didTouchStamp:(char)codeStamp
{
    [self createLabelWithChar:codeStamp];
}

- (void) createLabelWithChar:(char)codeStamp
{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:@"Sound FX" size:[Utilities sizeFrame]]];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%c", codeStamp];
    [label sizeToFit];
    CGFloat width = arc4random_uniform(self.mainView.frame.size.width - label.frame.size.width) + label.frame.size.width / 2;
    CGFloat height = arc4random_uniform(self.mainView.frame.size.height - label.frame.size.height) + label.frame.size.height / 2;
    label.center = CGPointMake(width, height);
    
    label.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch =
    [[UIPinchGestureRecognizer alloc] initWithTarget:[StampGestureHelper sharedInstance] action:@selector(handlePinch:)];
    [label addGestureRecognizer:pinch];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:[StampGestureHelper sharedInstance] action:@selector(handleRotation:)];
    [label addGestureRecognizer:rotation];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:[StampGestureHelper sharedInstance] action:@selector(handlePan:)];
    [label addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[StampGestureHelper sharedInstance] action:@selector(handleTap:)];
    [label addGestureRecognizer:tap];
    
    [self.mainView addSubview:label];
}

- (void)didTouchSpeechBubble:(char)codeBubble
{
    SpeechBubbleView *speech = [[SpeechBubbleView alloc] initWithCode:codeBubble andParent:self.mainView];
    [self.mainView addSubview:speech];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
