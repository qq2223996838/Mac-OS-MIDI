
//

#import "CustomProgress.h"

@interface CustomProgress ()
{
    NSImageView *bgimg;
    NSImageView *leftimg;
}
@end

@implementation CustomProgress


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [self InitializeUI];

}


-(void)InitializeUI
{
    self.layer.backgroundColor= [NSColor clearColor].CGColor;
    
    bgimg = [[NSImageView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    
    bgimg.wantsLayer =YES;//一定要加这一句，加载layer，否则画的东西显示不出来
    
    bgimg.layer.borderColor = [NSColor clearColor].CGColor;//设置边界颜色
    
    bgimg.layer.backgroundColor =  _bgimgColor.CGColor;
    
    bgimg.layer.borderWidth = 1;
    
    bgimg.layer.cornerRadius =0;//设置边角弧度
    
    [bgimg.layer setMasksToBounds:YES];
    
    [self addSubview:bgimg];
    
    
    
    leftimg = [[NSImageView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width/_maxValue*_present,self.frame.size.height)];
    
    leftimg.wantsLayer =YES;
    
    leftimg.layer.borderColor = [NSColor clearColor].CGColor;
    
    leftimg.layer.backgroundColor =  _leftimgColor.CGColor;
    
    leftimg.layer.borderWidth = 1;
    
    leftimg.layer.cornerRadius =0;
    
    [leftimg.layer setMasksToBounds:YES];
    
    [self addSubview:leftimg];
    
    
    
    [self setNeedsDisplay:YES];
}

-(void)setBgimgColor:(NSColor *)bgimgColor
{
    _bgimgColor = bgimgColor;
    return;
}

-(void)setLeftimgColor:(NSColor *)leftimgColor
{
    _leftimgColor = leftimgColor;
    return;
}

-(void)setMaxValue:(float)maxValue
{
    _maxValue = maxValue;
    return;
}

-(void)setPresent:(float)present

{
    _present = present;
    leftimg.frame =CGRectMake(0,0,self.frame.size.width/_maxValue*present,self.frame.size.height);

}

@end
