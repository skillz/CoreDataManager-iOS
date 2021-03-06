//
//  VIPagingFetchedResultsDataSource.h
//
//  Created by teejay on 1/21/14.
//

#import "VIFetchResultsDataSourceSKZ.h"
#import "VITableViewPagingManager.h"

@interface VIPagingFetchedResultsDataSource : VIFetchResultsDataSourceSKZ

/**
 *  This will structure and activate the paging functionality
 *
 *  @param overscrollTriggerDistance    The distance a user must scroll past the bounds to activate a page fetch
 
 *  @param upPageActionOrNil                 Executed when scrolling beyond the top bound of the tableView, do API actions here.
 *  @param headerViewOrNil                   View that will be inserted above the table, and notified of scrolling updates
 
 *  @param downPageActionOrNil               Executed when scrolling beyong the low bound of the tableView, do API actions here.
 *  @param footerViewOrNil                   View that will be inserted below the table, and notified of scrolling updates
 
 *  By not including either an action for a specified direction, the controller will not attempt to handle that direction
 */
- (void)setupForTriggerDistance:(CGFloat)overscrollTriggerDistance
                       upAction:(VIPagingResultsAction)upPageActionOrNil
                     headerView:(UIView<VIPagingAccessory> *)headerViewOrNil
                     downAction:(VIPagingResultsAction)downPageActionOrNil
                     footerView:(UIView<VIPagingAccessory> *)footerViewOrNil;


@end
