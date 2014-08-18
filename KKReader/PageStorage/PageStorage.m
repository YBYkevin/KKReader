//
//  PageStorage.m
//  KKReader
//
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "PageStorage.h"
 
@interface PageStorage ()
{
    NSMutableAttributedString *_storingText;
}

@end

@implementation PageStorage

- (id)init
{
    self = [super init];
    if (self) {
        _storingText = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

- (NSString *)string
{
    return [_storingText string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_storingText attributesAtIndex:location effectiveRange:range];
}

// Must override NSMutableAttributedString primitive method

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_storingText setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_storingText replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedAttributes | NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    [self endEditing];
    
}

@end
