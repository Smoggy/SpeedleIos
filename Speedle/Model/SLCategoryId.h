//
//  SLCategoryId.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 2/3/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Realm/Realm.h>

@interface SLCategoryId : RLMObject
@property NSString *categoryId;
@end

RLM_ARRAY_TYPE(SLCategoryId)
