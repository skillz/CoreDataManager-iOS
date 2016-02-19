//
//  SKZPlistMapExtensions.m
//  SkillzSDK-iOS
//
//  Created by John Graziano on 1/29/16.
//  Copyright © 2016 Skillz. All rights reserved.
//

#import "SKZPlistMapExtensions.h"
#import "VIManagedObject.h"
#import "VICoreDataManagerSKZ.h"
#import "VIManagedObjectMapperSKZ.h"

NSString *SKZArchivedClassName = @"_isa";


@implementation NSObject (SKZPlistMapExtensions)

- (id)createManagedObjectForKey:(NSString *)ownerKey owner:(id)owner context:(NSManagedObjectContext *)context
{
    return self;
}

@end

@implementation NSManagedObject (SKZPlistMapExtensions)

- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"Value requested for undefined key \"%@\" on class %@", key, [self class]);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"setValue requested for undefined key \"%@\" on class %@", key, [self class]);
}

@end


@implementation NSArray (SKZPlistMapExtensions)


- (id)createManagedObjectForKey:(NSString *)ownerKey owner:(id)owner context:(NSManagedObjectContext *)context
{
    NSUInteger count = [self count];
    id members[count];
    NSUInteger i = 0;
    
    for ( id plistObj in self )
    {
        members[i] = [plistObj createManagedObjectForKey:ownerKey owner:owner context:context];
        i++;
    }
    
    NSSet *memberSet = [NSSet setWithObjects:members count:count];
    return memberSet;
}

@end

@implementation NSDictionary (SKZPlistMapExtensions)

- (id)createManagedObjectForKey:(NSString *)ownerKey className:(NSString *)className owner:(id)owner context:(NSManagedObjectContext *)context
{
    id managedRootObject = nil;
    
    if ( className == nil )
    {
        return self;     // No class specifier found, return as raw dict
    }
    
    Class managedObjectClass = NSClassFromString(className);
    
    if ( managedObjectClass == Nil )
    {
        return self;    // No class found, return as raw dict
    }
    
    VICoreDataManagerSKZ *cdm = [VICoreDataManagerSKZ sharedInstance];
    context = [cdm safeContext:context];
    
    VIManagedObjectMapperSKZ *mapper = [cdm mapperForClass:managedObjectClass];
    
    NSString *comparisonKey = mapper.foreignUniqueComparisonKey;
    
    if ( comparisonKey != nil )
    {
        id comparisonValue = [self objectForKey:mapper.foreignUniqueComparisonKey];
        
        if ( comparisonValue != nil && ![comparisonValue isEqual:[NSNull null]] )
        {
            // check for existing object with matching key
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", mapper.uniqueComparisonKey, comparisonValue];
            
            NSError *error;
            NSArray *matchingObjects = [context executeFetchRequest:fetchRequest error:&error];
            
            if (error)
            {
                CDLog(@"%s Fetch Request Error\n%@",__PRETTY_FUNCTION__ ,[error localizedDescription]);
            }
            
            NSUInteger matchingObjectsCount = matchingObjects.count;
            
            if ( matchingObjectsCount > 0 )
            {
                NSAssert(matchingObjectsCount < 2, @"UNIQUE IDENTIFIER IS NOT UNIQUE. MORE THAN ONE MATCHING OBJECT FOUND");
                managedRootObject = matchingObjects[0];
            }
        }
    }
    
    if ( managedRootObject == nil )
    {
        // no match found, so create a new one
        managedRootObject = [cdm managedObjectOfClass:managedObjectClass inContext:context];
    }
    
    // assign properties and subobjects
    for ( NSString * inputKeyPath in self )
    {
        id plistValue = [self objectForKey:inputKeyPath];
        VIManagedObjectMapSKZ *map = [mapper mapForInputKeyPath:inputKeyPath];
        NSString *coreDataKey = map ? map.coreDataKey : inputKeyPath;
                        
        id managedSubObj = [plistValue createManagedObjectForKey:coreDataKey owner:managedRootObject context:context];

        // nil check necessary because NSString's createObject can return nil for the _isa key
        if ( managedSubObj != nil )
        {
            [managedRootObject safeSetValueSKZ:managedSubObj forKey:coreDataKey];
        }
    }
    
    return managedRootObject;
}

- (id)createManagedObjectForKey:(NSString *)ownerKey owner:(id)owner context:(NSManagedObjectContext *)context
{
    NSString *className = [self objectForKey:SKZArchivedClassName];
    
    return [self createManagedObjectForKey:ownerKey className:className owner:owner context:context];
}

@end

@implementation NSString (SKZPlistMapExtensions)

- (id)createManagedObjectForKey:(NSString *)ownerKey owner:(id)owner context:(NSManagedObjectContext *)context
{
    if ( ownerKey == nil || [ownerKey isEqualToString:SKZArchivedClassName] )
    {
        return nil;
    }
    
    VICoreDataManagerSKZ *cdm = [VICoreDataManagerSKZ sharedInstance];
    VIManagedObjectMapperSKZ *mapper = [cdm mapperForClass:[owner class]];
    VIManagedObjectMapSKZ *map = [mapper mapForCoreDataKey:ownerKey];
    
    id convertedObj = nil;
    
    if ( (convertedObj = [map.dateFormatter dateFromString:self]) != nil )
    {
        return convertedObj;
    }
    
    if ( (convertedObj = [map.numberFormatter numberFromString:self]) != nil )
    {
        return convertedObj;
    }
    
    return [super createManagedObjectForKey:ownerKey owner:owner context:context];
}
    
                             
@end


