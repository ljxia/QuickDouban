//
//  RestService.m
//  TypeLinkNav
//
//  Created by Josh Justice on 10/21/10.
//  Copyright 2010 Josh Justice. All rights reserved.
//

#import "RestService.h"


@implementation RestService

-(NSString *)requestToURL:(NSString *)url
				 response:(NSHTTPURLResponse **)response
{
	return [self requestToURL:url
					  headers:nil
					 response:response];
}

-(NSString *)requestToURL:(NSString *)url
				  headers:(NSDictionary *)headers
				 response:(NSHTTPURLResponse **)response
{
	return [self requestToURL:url
					   method:METHOD_GET
					  headers:headers
					 response:response];
}

-(NSString *)requestToURL:(NSString *)url
				   method:(NSString *)method
				  headers:(NSDictionary *)headers
				 response:(NSHTTPURLResponse **)response
{
	return [self requestToURL:url
					   method:method
						 body:nil
					  headers:headers
					 response:response];
}

-(NSString *)requestToURL:(NSString *)urlString
				   method:(NSString *)method
					 body:(NSString *)body
				  headers:(NSDictionary *)headers
				 response:(NSHTTPURLResponse **)response
{
	// create the url
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSLog(@"requesting %@, %@",method,url);
	NSLog(@"request body: %@", body);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	// set up the request
	if( nil != method ) {
		[request setHTTPMethod:method];
	}
	if( nil != body ) {
		NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
		[request setHTTPBody:bodyData];
	}
	if( nil != headers ) {
		NSEnumerator *e = [headers keyEnumerator];
		NSString *headerName;
		while( headerName = [e nextObject] ) {
			[request setValue:[headers objectForKey:headerName]
		   forHTTPHeaderField:headerName];
		}
	}
	
	// get the response
	NSHTTPURLResponse *myResponse = NULL;
	NSError *error = NULL;
	NSData *resultData = [NSURLConnection sendSynchronousRequest:request
										 returningResponse:&myResponse
													 error:&error];
	// pass response object back to user by reference
	*response = myResponse;
	
	// convert response body to string
	NSString *resultString = [[NSString alloc] initWithData:resultData
												   encoding:NSUTF8StringEncoding];
	NSLog(@"response body: %@", resultString);
	return resultString;
}

@end
