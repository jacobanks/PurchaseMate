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

    NSDictionary *productName = [self getDataFromOutPan:[NSString stringWithFormat:@"https://www.outpan.com/api/get-product.php?apikey=cbf4f07abd482df99358395a75b6340a&barcode=%@", ID]];
    if (productName == nil) {
        return nil;
    } else {
        NSString *corpName = [self getDataFromMongoDBWithDictionary:productName];
        if (corpName != nil) {
            NSDictionary *orgDict = [self getOrgIDWithURL:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=getOrgs&org=%@&apikey=0c8623858008df89e64bb8b1d7e4ca3d", corpName]];
            NSDictionary *politicalDictionary = [self getSummaryWithOrgID:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=orgSummary&id=%@&apikey=0c8623858008df89e64bb8b1d7e4ca3d", orgDict[@"orgid"]]];
            
            NSString *ethicsString = [self getEthicsRatingWithName:corpName];
            
            corpDict = [NSMutableDictionary dictionaryWithDictionary:@{ @"productName" : productName,
                                                                        @"corpName" : corpName,
                                                                        @"orgDict" : orgDict,
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

- (NSDictionary *)getOrgIDWithURL:(NSString *)urlstring {
    
    NSURL *URL = [[NSURL alloc] initWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSError *error = nil;
    
    NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&error];
    
    id response = [dictionary objectForKey:@"response"];
    NSDictionary *responseDictionary = response;
    id organization = [responseDictionary objectForKey:@"organization"];
    NSDictionary *orgDict = organization;
    
    return orgDict;
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
    NSDictionary *scoreDict = score;
    return [NSString stringWithFormat:@"%@", scoreDict];
}

@end
