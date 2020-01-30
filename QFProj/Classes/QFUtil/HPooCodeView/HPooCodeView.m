//
//  HPooCodeView.m
//  Code
//
//  Created by dqf on 2019/7/16.
//  Copyright © 2019 dqfStudio. All rights reserved.
//

#import "HPooCodeView.h"

#define HRGBColor(r, g, b , a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define HRandColor(a) HRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), a)

@interface HPooCodeView ()
@property (nonatomic) NSArray *changeArray; //随机内容
@end

@implementation HPooCodeView
- (id)initWithFrame:(CGRect)frame andChangeArray:(NSArray *)changeArr {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HRandColor(0.2);
        [self addTarget:self action:@selector(changeCodeAction) forControlEvents:UIControlEventTouchUpInside];
        _changeArray = changeArr;
        [self loadCode];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HRandColor(0.2);
        [self addTarget:self action:@selector(changeCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [self loadCode];
    }
    return self;
}
- (void)changeCodeAction {
    [self changeCode];
}
- (void)setChangeArray:(NSArray *)changeArray {
    if (_changeArray != changeArray) {
        _changeArray = nil;
        _changeArray = changeArray;
        [self changeCode];
    }
}
- (void)changeCode {
    [self loadCode];
    [self setNeedsDisplay];
}
- (void)loadCode {
    if (!self.changeArray.count) {
       self.changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    }
    NSMutableString *mutableString = NSMutableString.new;
    for (NSInteger i = 0; i < 4; i++){
        NSInteger index = arc4random() % ([self.changeArray count] - 1);
        NSString *string = [self.changeArray objectAtIndex:index];
        [mutableString appendString:string];
    }
    _changeString = mutableString;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    UIColor *color = HRandColor(0.5);
    [self setBackgroundColor:color];

    if (!_changeString) {
        return;
    }
    NSString *text = _changeString;
    CGSize cSize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_textSize>0?_textSize:20],NSForegroundColorAttributeName:_textColor?_textColor:[UIColor blackColor]}];
    int width = rect.size.width / text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    CGPoint point;

    float pX, pY;
    for (int i = 0; i < text.length; i++){
        
        pX = arc4random() % width + rect.size.width / text.length * i;
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
