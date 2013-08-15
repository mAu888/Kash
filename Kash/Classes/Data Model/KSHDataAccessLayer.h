/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;
@class NSManagedObjectContext;

@interface KSHDataAccessLayer : NSObject
@property(nonatomic, strong) NSManagedObjectContext *mainManagedObjectContext;

- (NSManagedObjectContext *)contextForEditing;

- (BOOL)saveContext:(NSManagedObjectContext *)context;

- (NSFetchedResultsController *)fetchedResultsControllerForClass:(Class)klass sortKey:(NSString *)sortKeyPath delegate:(id <NSFetchedResultsControllerDelegate>)delegate;

- (BOOL)deleteObject:(NSManagedObject *)object;

- (NSArray *)objectsForClass:(Class)klass sortKey:(NSString *)sortKey context:(NSManagedObjectContext *)context;

- (BOOL)objectInMainContext:(NSManagedObject *)object;

- (NSManagedObject *)objectTransferredToMainContext:(NSManagedObject *)object;

@end