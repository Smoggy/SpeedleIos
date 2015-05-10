//
//  SLImage.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/16/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Realm/Realm.h>

@interface SLImage : RLMObject
@property NSString *URLString;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SLImage>
RLM_ARRAY_TYPE(SLImage)
