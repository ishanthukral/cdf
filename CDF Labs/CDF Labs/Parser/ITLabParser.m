//
//  ITLabParser.m
//  CDF Labs
//
//  Created by Ishan Thukral on 2014-04-22.
//  Copyright (c) 2014 Ishan Thukral. All rights reserved.
//

#import "ITLabParser.h"
#import "ITConstants.h"
#import "ITLabStore.h"
#import "ITLab.h"
#import "TFHpple.h"

static ITLabParser *instance;

@implementation ITLabParser

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ITLabParser new];
    });
    return instance;
}

- (void)downloadLabData {
    
    NSURL *labUsageUrl = [NSURL URLWithString:kLabUsageUrl];
    NSData *htmlResponse = [NSData dataWithContentsOfURL:labUsageUrl];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlResponse];
    
    NSString *queryString = @"//tr";
    NSArray *nodes = [parser searchWithXPathQuery:queryString];
    
    [self filterDownloadedDataForResponse:nodes];
}

- (void)filterDownloadedDataForResponse:(NSArray *)response {
    
    [response enumerateObjectsUsingBlock:^(TFHppleElement *element, NSUInteger idx, BOOL *stop) {
       
        NSArray *elementArray = [element childrenWithTagName:@"td"];
        
        if ([elementArray count] > 0) {
            [self createLabWithData:elementArray];
        }
        
    }];
    
}

- (void)createLabWithData:(NSArray *)data {
    
    BOOL notALab = false;
    
    NSString *labNumber     = [[((TFHppleElement *)[data objectAtIndex:labName]) firstChild] content];
    NSString *machinesFree  = [[((TFHppleElement *)[data objectAtIndex:freeMachines]) firstChild] content];
    NSString *machinesBusy  = [[((TFHppleElement *)[data objectAtIndex:busyMachines]) firstChild] content];
    NSString *machinesTotal = [[((TFHppleElement *)[data objectAtIndex:totalMachines]) firstChild] content];
    
    NSString *labNameString;
    if ([labNumber isEqualToString:@"NX"]) {
        // TODO: Hacky fix, improve
        notALab = true;
    } else if ([labNumber isEqualToString:@"gerstein"]) {
        labNameString = labNumber.capitalizedString;
    } else {
        // Add BA to labNumber
        labNameString = [NSString stringWithFormat:@"BA %@", labNumber];
    }
    
    ITLab *lab = [[ITLab alloc] initWithLabName:labNameString
                               andTotalMachines:[NSNumber numberWithInteger:[machinesTotal integerValue]]
                                andFreeMachines:[NSNumber numberWithInteger:[machinesFree integerValue]]
                                andBusyMachines:[NSNumber numberWithInteger:[machinesBusy integerValue]]];
    
    if (!notALab) {
        [[ITLabStore sharedInstance] addLab:lab];
    }
}

@end
