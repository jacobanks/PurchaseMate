//
//  CorpInfo.m
//  PurchaseMate
//
//  Created by Jacob Banks on 1/20/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "CorpInfo.h"

@implementation CorpInfo

static NSMutableDictionary *corpDict;

- (NSDictionary *)getCorpInfoWithBarcode:(NSString *)ID {

    NSDictionary *productName = [self getDataFromOutPan:[NSString stringWithFormat:@"https://api.outpan.com/v2/products/%@?apikey=cbf4f07abd482df99358395a75b6340a", ID]];
    if (productName == nil) {
        return nil;
    } else {
        NSString *corpName = [self getDataFromMongoDBWithDictionary:productName];
        if (corpName != nil) {
            NSString *orgID = [self getOrgIDWithURL:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=getOrgs&org=%@&output=json&apikey=0c8623858008df89e64bb8b1d7e4ca3d", corpName]];
            NSDictionary *politicalDictionary = [self getSummaryWithOrgID:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=orgSummary&id=%@&apikey=0c8623858008df89e64bb8b1d7e4ca3d", orgID]];
            
            NSString *ethicsString = [self getEthicsRatingWithName:corpName];
            
            corpDict = [NSMutableDictionary dictionaryWithDictionary:@{ @"productName" : productName,
                                                                        @"corpName" : corpName,
                                                                        @"politicalInfo" : politicalDictionary,
                                                                        @"ethics" : ethicsString }];
            return corpDict;
        }
    }
    
    return nil;
}

- (NSDictionary *)getCorpDictionary {
    return corpDict;
}

- (NSDictionary *)getDataFromOutPan:(NSString *)urlString {
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    
    NSError *err;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:&err];
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &err];
    
    //Sort JSON from OutPan
    id attributes = [jsonArray objectForKey:@"attributes"];
    NSDictionary *responseDictionary = attributes;

    if ([responseDictionary count] != 0) {
        if (responseDictionary[@"Brand"]) {
            //Has Brand Attribute
            return responseDictionary[@"Brand"];
            
        } else if (responseDictionary[@"Manufacturer"]) {
            //Doesn't have Brand Attribute so check for Manufacturer            
            return responseDictionary[@"Manufacturer"];
        }
    }
    
    return nil;
}

- (NSString *)getDataFromMongoDBWithDictionary:(NSDictionary *)responseDictionary {
    
    NSError *error = nil;
    if (error) {
        NSLog(@"%@", error);
    }
    
    //Connect to MongoDB
    MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
    MongoDBCollection *collection = [dbConn collectionWithName:@"productDB.product"];
    
    MongoKeyedPredicate *predicate = [MongoKeyedPredicate predicate];
    [predicate keyPath:@"Name" matches:responseDictionary];
    BSONDocument *resultDoc = [collection findOneWithPredicate:predicate error:&error];
    NSDictionary *result = [BSONDecoder decodeDictionaryWithDocument:resultDoc];
    
    //Check if we have the product in our database
    if ([result objectForKey:@"Corp"] != nil) {
        //We have it
        id corp = [result objectForKey:@"Corp"];
        NSDictionary *corpDictionary = corp;

        return [NSString stringWithFormat:@"%@", corpDictionary];
    }
    
    return nil;
}

- (NSArray *)getAllCorps {
    
    NSError *error = nil;
    if (error) {
        NSLog(@"%@", error);
    }
    
    //Connect to MongoDB
    MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
    MongoDBCollection *collection = [dbConn collectionWithName:@"productDB.product"];
    
    NSArray *results = [collection findAllWithError:&error];
    NSMutableArray *corpArray = [[NSMutableArray alloc] init];;
    
    for (BSONDocument *resultDoc in results) {
        
        NSDictionary *result = [BSONDecoder decodeDictionaryWithDocument:resultDoc];
        id corp = [result objectForKey:@"Corp"];
        
        if (![corpArray containsObject:corp]) {
            [corpArray insertObject:corp atIndex:0];
        }
    }
    
    return corpArray;
}

- (NSArray *)getAllProductsWithCorpName:(NSString *)CorpName {
    NSError *error = nil;
    if (error) {
        NSLog(@"%@", error);
    }
    
    //Connect to MongoDB
    MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
    MongoDBCollection *collection = [dbConn collectionWithName:@"productDB.product"];
    
    MongoKeyedPredicate *predicate = [MongoKeyedPredicate predicate];
    [predicate keyPath:@"Corp" matches:CorpName];
    NSArray *results = [collection findWithPredicate:predicate error:&error];
    NSMutableArray *productArray = [[NSMutableArray alloc] init];;
    
    for (BSONDocument *resultDoc in results) {
        
        NSDictionary *result = [BSONDecoder decodeDictionaryWithDocument:resultDoc];
        id product = [result objectForKey:@"Name"];
        
        if (![productArray containsObject:product]) {
            [productArray insertObject:product atIndex:0];
        }
    }
    
    return productArray;

}

- (NSString *)getOrgIDWithURL:(NSString *)urlstring {
    
    NSURL *URL = [[NSURL alloc] initWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSError *error = nil;
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSString *orgID;
    
    if ([results[@"response"][@"organization"] count] > 1) {
        orgID = results[@"response"][@"organization"][0][@"@attributes"][@"orgid"];
    } else {
        orgID = results[@"response"][@"organization"][@"@attributes"][@"orgid"];
    }
    
    return orgID;
}

- (NSDictionary *)getSummaryWithOrgID:(NSString *)urlString {
    
    NSURL *URL = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSError *error = nil;
    
    NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&error];
    
    id response = [dictionary objectForKey:@"response"];
    NSDictionary *responseDictionary = response;
    id organization = [responseDictionary objectForKey:@"organization"];
    NSDictionary *summaryDict = organization;
    
    return summaryDict;
}

- (NSString *)getEthicsRatingWithName:(NSString *)name {
    NSError *error;
    MongoConnection *dbConn = [MongoConnection connectionForServer:@"45.55.207.148" error:&error];
    MongoDBCollection *collection = [dbConn collectionWithName:@"productDB.ethics"];
    
    MongoKeyedPredicate *predicate = [MongoKeyedPredicate predicate];
    [predicate keyPath:@"Name:" matches:name];
    BSONDocument *resultDoc = [collection findOneWithPredicate:predicate error:&error];
    NSDictionary *result = [BSONDecoder decodeDictionaryWithDocument:resultDoc];
    
    id score = [result objectForKey:@"Score:"];
    
    return [NSString stringWithFormat:@"%@", score];
}

@end
