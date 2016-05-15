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

// GETTERS
- (NSDictionary *)getPoliticalInfoWithBarcode:(NSString *)barcode;
- (NSDictionary *)getPoliticalInfoWithCorpName:(NSString *)corpName andProductName:(NSString *)productName;

- (NSDictionary *)getNamesWithBarcode:(NSString *)barcode;

- (NSDictionary *)getCorpDictionary;

// OUTPAN.COM API
- (NSDictionary *)getBrandFromOutPan:(NSString *)urlString;

// OPENSECRETS.COM API
- (NSString *)getOrgIDWithURL:(NSString *)urlstring;
- (NSDictionary *)getSummaryWithOrgID:(NSString *)urlString;

// MONGODB
- (NSString *)getCorpFromMongoDBWithBrandName:(NSDictionary *)productNameDictionary;

- (NSArray *)getAllCorps;
- (NSArray *)getAllProductsWithCorpName:(NSString *)corpName;

- (NSString *)getEthicsRatingWithName:(NSString *)name;

@end
