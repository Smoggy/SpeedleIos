//
//  NSDictionary+SLAdditions.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/16/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "NSDictionary+SLAdditions.h"

@implementation NSDictionary (SLAdditions)

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        const id object = self[key];
        if (object == nul) {
            [replaced setObject:blank forKey:key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject:[(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        } else if ([object isKindOfClass:[NSArray class]]) {
            NSMutableArray *newObject = [[NSMutableArray alloc] initWithArray:object copyItems:YES];
            for (id arrayObject in object) {
                if (arrayObject == nul) {
                    [newObject replaceObjectAtIndex:[object indexOfObject:arrayObject] withObject:blank];
                } else if ([object isKindOfClass: [NSDictionary class]]) {
                    [newObject addObject:[(NSDictionary *)arrayObject dictionaryByReplacingNullsWithStrings]];
                }
            }
            [replaced setObject:newObject forKey:key];
        }
    }
    return [replaced copy];
}

@end
