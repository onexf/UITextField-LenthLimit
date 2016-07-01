//
//  UITextField+LenthLimit.m
//  Lists
//
//  Created by pg on 16/7/1.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "UITextField+LenthLimit.h"
#import <objc/runtime.h>
static NSString * const DRNMaxLengthKey = @"DRNMaxLengthKey";

@implementation UITextField (LenthLimit)

@dynamic maxLength;

#pragma mark - Getter

- (NSInteger)maxLength
{
    NSValue *maxLengthValue = objc_getAssociatedObject(self, &DRNMaxLengthKey);
    if (maxLengthValue) {
        NSInteger maxLength;
        [maxLengthValue getValue:&maxLength];
        return maxLength;
    }
    
    return NSIntegerMax;
}

#pragma mark - Setter

- (void)setMaxLength:(NSInteger)maxLength
{
    if (maxLength < 1) {
        maxLength = NSIntegerMax;
    }
    
    NSValue *value = [NSValue value:&maxLength withObjCType:@encode(NSInteger)];
    objc_setAssociatedObject(self, &DRNMaxLengthKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self textFieldTextChanged:self];
    [self removeTarget:self
                action:@selector(textFieldTextChanged:)
      forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self
             action:@selector(textFieldTextChanged:)
   forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Event

- (void)textFieldTextChanged:(UITextField *)textField
{
    NSInteger adaptedLength = MIN(textField.text.length, textField.maxLength);
    NSRange range = NSMakeRange(0, adaptedLength);
    textField.text = [textField.text substringWithRange:range];
}
@end
