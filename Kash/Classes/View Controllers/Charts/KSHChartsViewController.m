/**
* Created by Maurício Hanika on 15.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import "KSHChartsViewController.h"
#import "KSHDataAccessLayer.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHChartsViewController ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHChartsViewController
{
    KSHDataAccessLayer *_dataAccessLayer;
}

- (id)initWithDataAccessLayer:(KSHDataAccessLayer *)dataAccessLayer
{
    self = [super init];

    if ( self != nil )
    {
        _dataAccessLayer = dataAccessLayer;
        
        self.title = NSLocalizedString(@"Charts", nil);

        // Tab item ------------------------------------------------------------
        self.tabBarItem.title = NSLocalizedString(@"Charts", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"chart"];

        // Navigation item -----------------------------------------------------

    }

    return self;
}


@end