//
//  SLAdvert.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Realm/Realm.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "SLCategory.h"
#import "SLCategoryId.h"
#import "SLImage.h"
#import "SLAdvert.h"

@interface SLAdvert : RLMObject
@property NSString *advertId;
@property NSString *advertName;
@property NSString *advertInfo;
@property BOOL isActive;
@property CGFloat price;
@property NSString *ownerName;
@property NSString *ownerId;
@property NSString *phoneNumber;
@property NSInteger numberOfViews;
@property NSDate *created;
@property NSString *email;
@property NSString *currency;
@property NSDate *lastChanged;
@property NSString *advertDescription;
@property RLMArray<SLImage> *imagesList;
@property RLMArray<SLImage> *thumbnailsList;
@property RLMArray<SLCategoryId> *categoriesIds;

//ignored
@property UIImage *pickedImage;
@property (strong, nonatomic) NSArray *categories;

+ (void)insertAdvertisement:(SLAdvert *)advert;
+ (void)removeAdvertisement:(SLAdvert *)advert;
+ (void)createOrUpdateAdvertsWithResponse:(NSArray *)response;
+ (void)createOrUpdateInMemoryAdvertsWithResponse:(NSArray *)response;
+ (void)createOrUpdateAdvertWithResponse:(NSDictionary *)response inRealm:(RLMRealm *)realm;
- (BOOL)updateCategoriesWithCategory:(SLCategory *)category;
+ (RLMResults *)currentUserAdverts;
+ (RLMResults *)allInMemoryAdverts;
+ (void)clearInMemoryDatabase;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SLAdvert>
RLM_ARRAY_TYPE(SLAdvert)

/*
 {
 __v: int - Version  *
 _id: int - id   *
 name: String,
 info: String,   *
 active: Boolean,    *
 images: [String],
 price: Number,
 currency: String,
 ownerName: String,
 email: String,
 phoneNumber: String,
 categories: [{Type Schema.Types.ObjectId, ref: *Category' }],
 description: String,
 owner: {type: Schema.Types.ObjectId, ref: 'User'},  *
 views: {type: Number, default: 0},  *
 created: { type: Date, default: Date.now }, *
 lastChanged: { type: Date, default: Date.now }, *
 }
 */
