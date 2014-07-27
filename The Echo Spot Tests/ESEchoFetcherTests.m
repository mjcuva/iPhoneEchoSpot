//
//  ESEchoFetcherTests.m
//  The Echo Spot
//
//  Created by Marc Cuva on 7/27/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ESEchoFetcher.h"
#import "ESEcho.h"

@interface ESEchoFetcherTests : XCTestCase

@end

@implementation ESEchoFetcherTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchRecentEchosCount{
    NSArray *arr = [ESEchoFetcher loadRecentEchos];
    XCTAssertTrue([arr count] > 0, @"Should Have Echos");
}

@end
