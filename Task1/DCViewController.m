//
//  DCViewController.m
//  Task1
//
//  Created by Ivan Felipe Gazabon on 2/16/13.
//  Copyright (c) 2013 David Andrés Céspedes. All rights reserved.
//

#import "DCViewController.h"
#import "DCConnection.h"

@interface DCViewController ()

@end

@implementation DCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ConnectAction:(id)sender {
    DCConnection * connection = [[DCConnection alloc] init];
    [connection connectToYCombinator];
    self.textWebLabel.text = @"Loading ...";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLableText:)
                                                 name:@"ConnectionFinished"
                                               object:nil];
    
}

-(void)changeLableText:(NSNotification *) aNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ConnectionFinished"
                                                  object:nil];
    
    //Change label text
    
     NSString * firstNewsText = [aNotification.userInfo objectForKey:@"dataString"];
    self.textWebLabel.text = firstNewsText;
    
    
}
@end
