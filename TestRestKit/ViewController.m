//
//  ViewController.m
//  TestRestKit
//
//  Created by Sergey on 12/1/15.
//  Copyright © 2015 Sergey. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>

@interface Article : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, copy) NSString* author;
@property (nonatomic) NSDate*   publicationDate;
@end

@implementation Article


@end

@interface ViewController ()

@end

@interface TestObject : NSObject
- (void)test;
@end

@implementation TestObject

- (void)test
{
    NSLog(@"+++++++++++++++++++");
}
-(void)dealloc
{
    NSLog(@"======================");
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
    
    
    RKObjectMapping* articleMapping = [RKObjectMapping mappingForClass:[Article class]];
    [articleMapping addAttributeMappingsFromDictionary:@{
                                                         @"title": @"title",
                                                         @"body": @"body",
                                                         @"author": @"author",
                                                         @"publication_date": @"publicationDate"
                                                         }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:articleMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"articles" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:@"http://restkit.org/articles"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    __block TestObject* test = [TestObject new];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Articles: %@", mappingResult.array);
        //[test test];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
        [test test];
    }];
    
    [objectRequestOperation start];
    
    /*
    __block TestObject* test = [TestObject new];
    void(^block)() = ^(){
        [test test];
    };
    int k = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(k)
            block();
    });*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
