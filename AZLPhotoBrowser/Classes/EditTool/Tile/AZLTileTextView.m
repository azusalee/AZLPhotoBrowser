//
//  AZLTileTextView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import "AZLTileTextView.h"
#import <AZLExtend/AZLExtend.h>

@interface AZLTileTextView()<UITextViewDelegate>


@end

@implementation AZLTileTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.delegate = self;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:14];
        [self addSubview:_textView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)viewDidTap:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded){
        self.textView.userInteractionEnabled = YES;
        [self.textView becomeFirstResponder];
        
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    self.transform = CGAffineTransformIdentity;
    CGFloat textHeight = [textView.text boundingRectWithSize:CGSizeMake(84, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+20;
    
    self.height = textHeight;
    [self updateTransform];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    textView.userInteractionEnabled = NO;
}

@end
