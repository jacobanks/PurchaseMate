//
//  CorpInfo.h
//  PurchaseMate
//
//  Created by Jacob Banks on 1/20/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLReader.h"
#import "AppDelegate.h"
#import "ObjCMongoDB.h"
#import "ViewController.h"

@interface CorpInfo : NSObject

- (NSDictionary *)getDataFromOutPan:(NSString *)urlString;
- (NSDictionary *)getDataFromMongoDBWithDictionary:(NSDictionary *)responseDictionary;
- (NSString *)getOrgIDWithURL:(NSString *)urlstring;
- (NSString *)getSummaryWithOrgName:(NSString *)urlString;
- (NSString *)getEthicsRatingWithName:(NSString *)name;

@end
