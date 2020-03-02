//
//  HVerifyCodeView.m
//  Code
//
//  Created by dqf on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HVerifyCodeView.h"

#define HRGBColor(r, g, b , a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define HRandColor(a) HRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), a)

@implementation HVerifyCodeView
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HRandColor(0.2);
        [self addTarget:self action:@selector(verifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [self loadCode];
    }
    return self;
}
- (void)verifyCodeAction {
    [self refreshVerifyCode];
}
- (void)setCharsArray:(NSArray *)charsArray {
    if (_charsArray != charsArray) {
        _charsArray = nil;
        _charsArray = charsArray;
        [self refreshVerifyCode];
    }
}
- (void)refreshVerifyCode {
    [self loadCode];
    [self setNeedsDisplay];
}
- (void)loadCode {
    if (!_charsArray.count) {
       _charsArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    }
    NSMutableString *mutableString = NSMutableString.new;
    for (NSInteger i = 0; i < 4; i++){
        NSInteger index = arc4random() % ([_charsArray count] - 1);
        NSString *string = [_charsArray objectAtIndex:index];
        [mutableString appendString:string];
    }
    _verifyCodeString = mutableString;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    UIColor *color = HRandColor(0.5);
    [self setBackgroundColor:color];

    if (!_verifyCodeString) {
        return;
    }
    NSString *text = _verifyCodeString;
    CGSize cSize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_textSize>0?_textSize:20],NSForegroundColorAttributeName:_textColor?_textColor:[UIColor blackColor]}];
    int width = rect.size.width / text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    CGPoint point;

    float pX, pY;
    for (int i = 0; i < text.length; i++){
        
        pX = arc4random() % width + rect.size.width / text.length *i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_textSize>0?_textSize:20],NSForegroundColorAttributeName:_textColor?_textColor:[UIColor blackColor]}];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    for (int cout = 0; cout < 10; cout++){
        
        color = HRandColor(0.2);
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextMoveToPoint(context, pX, pY);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        CGContextStrokePath(context);
    }
}
@end
