/**
* Created by Maurício Hanika on 15.12.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Colours/UIColor+Colours.h>
#import "KSHTableViewController.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHTableViewController ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHTableViewController

- (UITableViewHeaderFooterView *)tableHeaderFooterViewWithTitle:(NSString *)title
{
    UITableViewHeaderFooterView *view = nil;
    if ( title != nil )
    {
        static NSString *reuseIdentifier = @"KSHTableHeaderFooterView";

        view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
        if ( view == nil)
        {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:reuseIdentifier];

            UIFontDescriptor *fontDescriptor =
                [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];
            view.textLabel.font = [UIFont fontWithName:@"OpenSans" size:[fontDescriptor pointSize]];
            view.textLabel.textColor = [UIColor coolGrayColor];
        }

        view.textLabel.text = [title uppercaseString];
    }

    return view;
}

@end