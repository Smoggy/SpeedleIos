//
//  SLCategory.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Realm/Realm.h>
#import <Realm+JSON/RLMObject+JSON.h>

@interface SLCategory : RLMObject
@property NSString *categoryId;
@property NSString *name;
@property BOOL isActive;

+ (void)createOrUpdateCategoriesWithResponse:(NSArray *)response;
+ (void)insertCategory:(SLCategory *)category;
@end

RLM_ARRAY_TYPE(SLCategory)
