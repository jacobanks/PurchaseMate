//
//  CorpInfo.m
//  PurchaseMate
//
//  Created by Jacob Banks on 1/20/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "CorpInfo.h"

@implementation CorpInfo

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
    
    if (responseDictionary[@"Brand"]) {
        //Has Brand Attribute
        productName = [NSString stringWithFormat:@"%@", responseDictionary[@"Brand"]];
        
        return responseDictionary[@"Brand"];
        
    } else if (responseDictionary[@"Manufacturer"]) {
        //Doesn't have Brand Attribute so check for Manufacturer
        productName = [NSString stringWithFormat:@"%@", responseDictionary[@"Manufacturer"]];
        
        return responseDictionary[@"Manufacturer"];
        
    } else {
        // TODO : show alert
    }
    
    return nil;
}

- (NSDictionary *)getDataFromMongoDBWithDictionary:(NSDictionary *)responseDictionary {
    
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
        
//        [self getEthicsRatingWithName:[NSString stringWithFormat:@"%@", corpDictionary]];
//        
//        [self getOrgIDWithURL:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=getOrgs&org=%@&apikey=0c8623858008df89e64bb8b1d7e4ca3d", corpDictionary]];
        
        return corpDictionary;
    }
    
    return nil;
}

- (NSString *)getOrgIDWithURL:(NSString *)urlstring {
    
    NSURL *URL = [[NSURL alloc] initWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSError *error = nil;
    
    NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&error];
    
    id response = [dictionary objectForKey:@"response"];
    NSDictionary *responseDictionary = response;
    id organization = [responseDictionary objectForKey:@"organization"];
    NSDictionary *orgIDDict = organization;
    
    id orgID = [orgIDDict objectForKey:@"orgid"];
    id orgName = [orgIDDict objectForKey:@"orgname"];
    
    organizationName = orgName;
    
    [self getSummaryWithOrgName:[NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=orgSummary&id=%@&apikey=0c8623858008df89e64bb8b1d7e4ca3d", orgID]];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)getSummaryWithOrgName:(NSString *)urlString {
    
    NSURL *URL = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSError *error = nil;
    
    NSDictionary *dictionary = [XMLReader dictionaryForXMLData:data error:&error];
    
    AppDelegate *app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    id response = [dictionary objectForKey:@"response"];
    NSDictionary *responseDictionary = response;
    id organization = [responseDictionary objectForKey:@"organization"];
    NSDictionary *summaryDict = organization;
    
    app.valuesArray = [[NSMutableArray alloc] initWithArray:[summaryDict allValues]];
    app.keysArray = [[NSMutableArray alloc] initWithArray:[summaryDict allKeys]];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
