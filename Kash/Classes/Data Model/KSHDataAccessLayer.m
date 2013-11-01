/**
* Created by Maurício Hanika on 09.08.13.
* Copyright (c) 2013 Maurício Hanika. All rights reserved.
*/

#import <CoreData/CoreData.h>
#import "KSHDataAccessLayer.h"
#import "KSHAccount.h"

////////////////////////////////////////////////////////////////////////////////
@interface KSHDataAccessLayer ()

@end


////////////////////////////////////////////////////////////////////////////////
@implementation KSHDataAccessLayer
{
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

- (id)init
{
    self = [super init];

    if ( self != nil )
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KSHDataModel"
                                                  withExtension:@"momd"];

        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

        NSError *error = nil;
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *storeURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"KSHDataStore.sqlite"]];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:nil
                                                          error:&error];

        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;


        // Notifications -------------------------------------------------------
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }

    return self;
}

- (NSManagedObjectContext *)contextForEditing
{
    NSManagedObjectContext *context =
            [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = _persistentStoreCoordinator;

    return context;
}

- (BOOL)saveContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;

    if ( ![context save:&error] )
    {
        NSLog(@"Error saving context: %@", error.localizedDescription);
        return NO;
    }

    return YES;
}

- (NSFetchedResultsController *)fetchedResultsControllerForClass:(Class)klass
                                                 sortDescriptors:(NSArray *)sortDescriptors
                                              sectionNameKeyPath:(NSString *)sectionName
                                                       cacheName:(NSString *)cacheName
                                                        delegate:(id <NSFetchedResultsControllerDelegate>)delegate
{
    NSFetchRequest *fetchRequest =
            [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(klass)];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.sortDescriptors = sortDescriptors;

    NSFetchedResultsController *controller =
            [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                managedObjectContext:_mainManagedObjectContext
                                                  sectionNameKeyPath:sectionName
                                                           cacheName:cacheName];
    controller.delegate = delegate;

    NSError *error = nil;
    if ( ![controller performFetch:&error] )
    {
        NSLog(@"Performing fetch failed: %@", error.localizedDescription);
        return nil;
    }

    return controller;
}

- (BOOL)deleteObject:(NSManagedObject *)object
{
    [_mainManagedObjectContext deleteObject:object];

    return [self saveContext:_mainManagedObjectContext];
}

- (NSArray *)objectsForClass:(Class)klass sortKey:(NSString *)sortKey context:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(klass)];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey
                                                                   ascending:YES]];

    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest
                                             error:&error];

    if ( result == nil)
    {
        NSLog(@"Error performing fetch: %@", error.localizedDescription);
    }

    return result;
}

- (BOOL)objectInMainContext:(NSManagedObject *)object
{
    return [object.managedObjectContext isEqual:_mainManagedObjectContext];
}
- (NSManagedObject *)objectTransferredToMainContext:(NSManagedObject *)object
{
    return [_mainManagedObjectContext objectWithID:object.objectID];
}


#pragma mark - Private methods

- (void)contextDidSave:(NSNotification *)notification
{
    NSManagedObjectContext *context = notification.object;
    if ( context != _mainManagedObjectContext )
    {
        [_mainManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }
}

- (NSManagedObjectContext *)contextWithParentContext:(NSManagedObjectContext *)parentContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]
        initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = parentContext;

    return context;
}
@end