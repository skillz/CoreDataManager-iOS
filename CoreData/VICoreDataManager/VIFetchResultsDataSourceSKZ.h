//
//  VIFetchResultsDataSource.h
//  CoreData
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol VIFetchResultsDataSourceDelegateSKZ <NSObject>
@optional
- (void)fetchResultsDataSourceSelectedObject:(NSManagedObject *)object;
- (void)fetchResultsDataSourceHasResults:(BOOL)hasResults;
@end

@interface VIFetchResultsDataSourceSKZ : NSObject <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (readonly) Class managedObjectClass;
@property (weak, readonly) UITableView *tableView;
@property (weak, readonly) NSManagedObjectContext *managedObjectContext;

@property (weak) id <VIFetchResultsDataSourceDelegateSKZ> delegate;

//these are exposed to handle reconfiguration of the protected _fetchedResultsController, when they change
@property (nonatomic, assign) NSInteger batchSize;
@property (nonatomic, assign) NSInteger fetchLimit;

@property (nonatomic, weak) NSPredicate *predicate;
@property (nonatomic, weak) NSArray *sortDescriptors;

//whether to deselect the selected cell of the table view
//after sending the selected object to the delegate
//defaults to YES
@property BOOL clearsTableViewCellSelection;

//you can ignore deprecation warnings in subclasses
@property (strong, readonly) NSFetchedResultsController *fetchedResultsController;

- (NSArray *)fetchedObjects;

- (id)objectAtIndexPath:(NSIndexPath *)path;

- (void)reloadData;

- (id)initWithPredicate:(NSPredicate *)predicate
              cacheName:(NSString *)cacheName
              tableView:(UITableView *)tableView
     sectionNameKeyPath:(NSString *)sectionNameKeyPath
        sortDescriptors:(NSArray *)sortDescriptors
     managedObjectClass:(Class)managedObjectClass;

- (id)initWithPredicate:(NSPredicate *)predicate
              cacheName:(NSString *)cacheName
              tableView:(UITableView *)tableView
     sectionNameKeyPath:(NSString *)sectionNameKeyPath
        sortDescriptors:(NSArray *)sortDescriptors
     managedObjectClass:(Class)managedObjectClass
              batchSize:(NSInteger)batchSize;

- (id)initWithPredicate:(NSPredicate *)predicate
              cacheName:(NSString *)cacheName
              tableView:(UITableView *)tableView
     sectionNameKeyPath:(NSString *)sectionNameKeyPath
        sortDescriptors:(NSArray *)sortDescriptors
     managedObjectClass:(Class)managedObjectClass
               delegate:(id <VIFetchResultsDataSourceDelegateSKZ>)delegate;

- (id)initWithPredicate:(NSPredicate *)predicate
              cacheName:(NSString *)cacheName
              tableView:(UITableView *)tableView
     sectionNameKeyPath:(NSString *)sectionNameKeyPath
        sortDescriptors:(NSArray *)sortDescriptors
     managedObjectClass:(Class)managedObjectClass
              batchSize:(NSInteger)batchSize
               delegate:(id <VIFetchResultsDataSourceDelegateSKZ>)delegate;

- (id)initWithPredicate:(NSPredicate *)predicate
              cacheName:(NSString *)cacheName
              tableView:(UITableView *)tableView
     sectionNameKeyPath:(NSString *)sectionNameKeyPath
        sortDescriptors:(NSArray *)sortDescriptors
     managedObjectClass:(Class)managedObjectClass
              batchSize:(NSInteger)batchSize
             fetchLimit:(NSInteger)fetchLimit
               delegate:(id <VIFetchResultsDataSourceDelegateSKZ>)delegate;

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;

@end
