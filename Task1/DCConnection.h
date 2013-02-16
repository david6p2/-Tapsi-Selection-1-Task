//
//  DCConnection.h
//  Task1
//
//  Created by Ivan Felipe Gazabon on 2/16/13.
//  Copyright (c) 2013 David Andrés Céspedes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCConnection : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData * receivedData;
}


@property(nonatomic, strong) NSMutableData *receivedData;

-(void)connectToYCombinator;

@end
