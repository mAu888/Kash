//  CATextLayer+AutoSizing.h
//
//  Created by Andrew Bulhak on 02/08/2013.
//  This code is placed in the public domain`
//  http://tech.null.org/item/201308021725_automatically_catext

#import <QuartzCore/QuartzCore.h>

@interface CATextLayer (AutoSizing)

- (void) adjustBoundsToFit;

@end