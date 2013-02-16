//
//  DCConnection.m
//  Task1
//
//  Created by Ivan Felipe Gazabon on 2/16/13.
//  Copyright (c) 2013 David Andrés Céspedes. All rights reserved.
//

#import "DCConnection.h"
#import "TFHpple.h"

@implementation DCConnection
@synthesize receivedData=_receivedData;

-(void)connectToYCombinator{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.ycombinator.com"]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
        NSString * stringSuccessForConnectionLog = [NSString stringWithFormat:@"The connection has STARTED!"];
        NSLog(@"%@", stringSuccessForConnectionLog);
        
    } else {
        // Inform the user that the connection failed.
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[connectFailMessage show];
        NSString * stringFailedForConnectionLog = [NSString stringWithFormat:@"The connection has FAILED!"];
        NSLog(@"%@", stringFailedForConnectionLog);
    }
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // receivedData is an instance variable declared on top of this class.
    
    [_receivedData setLength:0];
    //NSString * responseStatusCodeStr = [[NSString alloc] initWith:(NSURLResponse *)response];
    NSLog(@"The URL Response is :%@", response.URL);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // receivedData is declared as a method instance elsewhere

    // inform the user
    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message: @"didFailWithError"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [didFailWithErrorMessage show];
	
    //inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    // 2
    TFHpple *newsParser = [TFHpple hppleWithHTMLData:self.receivedData];
    
    // 3
    NSString *newsXpathQueryString = @"//td[@class='title']/a";
    NSArray *newsNodes = [newsParser searchWithXPathQuery:newsXpathQueryString];
    
    // 4
    NSMutableArray *newNews = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in newsNodes) {
        // 5
        NSString *newsTitle = [[NSString alloc] init];
        
        
        newsTitle = [[element firstChild] content];
        //NSLog(@"newsTitle:\n%@",newsTitle);
        [newNews addObject:newsTitle];
        
        
        
        
    }
     
    
    
    // do something with the data
    
    
    NSString *dataString = [newNews objectAtIndex:0];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:@[dataString] forKeys:@[@"dataString"]];
    
    //alert the user
                        
    NSLog(@"Received %d bytes",[self.receivedData length]);
    NSLog(@"Array:\n%@",newNews);
    NSLog(@"Dictionary:\n%@",dictionary);
    UIAlertView *finishedLoadingMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message:@"Connection Success!"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [finishedLoadingMessage show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectionFinished"
                                                        object:self
                                                      userInfo:dictionary];
    
    
}




@end
