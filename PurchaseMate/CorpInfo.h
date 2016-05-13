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

- (NSDictionary *)getCorpInfoWithBarcode:(NSString *)ID;
- (NSDictionary *)getCorpInfo:(NSString *)corp andProductName:(NSString *)productName;
- (NSDictionary *)getCorpAndNameWithBarcode:(NSString *)barcode;

- (NSDictionary *)getDataFromOutPan:(NSString *)urlString;
- (NSString *)getDataFromMongoDBWithDictionary:(NSDictionary *)responseDictionary;
    
- (NSArray *)getAllCorps;
- (NSArray *)getAllProductsWithCorpName:(NSString *)CorpName;

- (NSString *)getOrgIDWithURL:(NSString *)urlstring;
- (NSDictionary *)getSummaryWithOrgID:(NSString *)urlString;

- (NSString *)getEthicsRatingWithName:(NSString *)name;

- (NSDictionary *)getCorpDictionary;

@end
