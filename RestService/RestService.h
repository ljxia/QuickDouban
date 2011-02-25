//
//  RestService.h
//  TypeLinkNav
//
//  Created by Josh Justice on 10/21/10.
//  Copyright 2010 Josh Justice. All rights reserved.
//

#import <Foundation/Foundation.h>

#define METHOD_GET @"GET"
#define METHOD_PUT @"PUT"
#define METHOD_POST @"POST"
#define METHOD_DELETE @"DELETE"

@interface RestService : NSObject {

}

-(NSString *)requestToURL:(NSString *)url
				 response:(NSHTTPURLResponse **)response;

-(NSString *)requestToURL:(NSString *)url
				  headers:(NSDictionary *)headers
				 response:(NSHTTPURLResponse **)response;

-(NSString *)requestToURL:(NSString *)url
				   method:(NSString *)method
				  headers:(NSDictionary *)headers
				 response:(NSHTTPURLResponse **)response;

-(NSString *)requestToURL:(NSString *)url
				   method:(NSString *)method
					 body:(NSString *)body
				  headers:(NSDictionary *)headers
				 response:(NSHTTPURLResponse **)response;

@end
