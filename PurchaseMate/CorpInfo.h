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

/** Executes an HTTP GET command and retrieves the political information with a barcode.
 * \param barcode The barcode number needed to perform the GET operation
 * \returns A NSDictionary of political information about the corporation
 */
- (NSDictionary *)getPoliticalInfoWithBarcode:(NSString *)barcode;

/** Executes an HTTP GET command and retrieves the political information with a corporation name.
 * \param corpName The corporation name for the needed political information
 * \param productName The product name for the needed political information
 * \returns A NSDictionary of political information about the corporation
 */
- (NSDictionary *)getPoliticalInfoWithCorpName:(NSString *)corpName andProductName:(NSString *)productName;

/** Executes an HTTP GET command and retrieves the corporation name and product name using a barcode number.
 * \param barcode The barcode number needed to perform the GET operation
 * \returns A NSDictionary of the corporation and product name
 */
- (NSDictionary *)getNamesWithBarcode:(NSString *)barcode;

/** Returns a static NSDicationary from the CorpInfo class.
 * \returns A static NSDictionary from the CorpInfo class
 */
- (NSDictionary *)getCorpDictionary;

/////////// OUTPAN.COM API ///////////
/** Executes an HTTP GET command to outpan.com and retrieves the product name.
 * \param urlString The URL needed to perform the GET operation
 * \returns A NSDictionary of the product name
 */
- (NSDictionary *)getBrandFromOutPan:(NSString *)urlString;

/////////// OPENSECRETS.ORG API ///////////
/** Executes an HTTP GET command to opensecrets.org and retrieves the organization id.
 * \param urlString The URL using the corporation name needed to perform the GET operation
 * \returns A NSString of the organization id
 */
- (NSString *)getOrgIDWithURL:(NSString *)urlstring;

/** Executes an HTTP GET command to opensecrets.org and retrieves the needed political information.
 * \param urlString The URL using the organization id needed to perform the GET operation
 * \returns A NSDicationary of the needed political information
 */
- (NSDictionary *)getSummaryWithOrgID:(NSString *)urlString;

/////////// MONGODB ///////////
/** Executes an HTTP GET command to mongodb server and searches through a list of products to match a product with a corporation.
 * \param productNameDictionary The URL using the organization id needed to perform the GET operation
 * \returns A NSString of the corporation name
 */
- (NSString *)getCorpFromMongoDBWithBrandName:(NSDictionary *)productNameDictionary;

/** Executes an HTTP GET command to mongodb server to retrieve all corporation names.
 * \returns A NSArray of all corporations in the mongodb database
 */
- (NSArray *)getAllCorps;

/** Executes an HTTP GET command to mongodb server to retrieve all product names with a given corporation name.
 * \param corpName The corporation name used to search retrieve all products
 * \returns A NSArray of all the retrieved product names
 */
- (NSArray *)getAllProductsWithCorpName:(NSString *)corpName;

/** Executes an HTTP GET command to mongodb server to retrieve the ethics rating of a given corporation.
 * \param name The corporation name used to search retrieve the ethics rating
 * \returns A NSString of the ethics rating
 */
- (NSString *)getEthicsRatingWithName:(NSString *)name;

@end
