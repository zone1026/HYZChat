//
//  DataManager.m
//  Timetable
//
//  Created by 黄亚州 on 2017/8/14.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "DataManager.h"

static NSString *const coreDataModelFileName = @"HYZChat";

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handelApplicationDidEnterBackgroundNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)handelApplicationDidEnterBackgroundNotification:(NSNotification *)notification {
    [self saveContext];
}

#pragma mark - CoreData stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDatabaseDirectory {
    NSString *coreDataDir = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/CoreData/"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:coreDataDir] == NO) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:coreDataDir withIntermediateDirectories:YES attributes:nil error:&error];
        if(error != nil){
            NSLog(@"Error: %@", error);
        }
    }
    return [NSURL fileURLWithPath:[coreDataDir stringByAppendingString:[NSString stringWithFormat:@"%@.sqlite", coreDataModelFileName]]];
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        if (self.persistentStoreCoordinator == nil) {
            return nil;
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:coreDataModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *storeURL = [self applicationDatabaseDirectory];
        NSLog(@"数据库地址：%@", storeURL.absoluteString);
        NSError *error = nil;
        NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                           NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                           NSInferMappingModelAutomaticallyOption, nil];//自动轻量级迁移
        if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error] == nil) {
            NSLog(@"Failed to initialize the application's saved data");
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - core data save

- (void)saveContext {
    if (self.managedObjectContext != nil) {
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && [self.managedObjectContext save:&error] == NO)
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        else
            NSLog(@"数据存储成功");
    }
}

#pragma mark - core data using implementation

- (NSArray *)arrayFromCoreData:(NSString *)entityName predicate:(NSPredicate *)predicate limitNum:(NSUInteger)num offset:(NSUInteger)offset orderBy:(NSArray *)sortDescriptors {
    NSEntityDescription *entiy = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entiy];
    if (sortDescriptors != nil && sortDescriptors.count > 0) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    
    [request setFetchLimit:num];
    [request setFetchOffset:offset];
    NSError *error = nil;
    NSArray *fetchObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"fetch request error = %@", error);
        return nil;
    }
    return fetchObjects;
}

- (NSManagedObject *)insertIntoCoreData:(NSString *)entityName {
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    return obj;
}

- (void)deleteFromCoreData:(NSManagedObject *)obj {
    if (obj != nil) {
        [self.managedObjectContext deleteObject:obj];
    }
}

- (void)cleanCoreDatabyEntityName:(NSString *)entityName {
    NSArray *dbArray = [self arrayFromCoreData:entityName predicate:nil limitNum:NSIntegerMax offset:0 orderBy:nil];
    if (dbArray != nil && dbArray.count > 0) {
        for (NSManagedObject *obj in dbArray) {
            [self deleteFromCoreData:obj];
        }
    }
}

- (CNUser *)findUserFromCoredataByPhone:(NSString*)phoneStr {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_phone = %@", phoneStr];
    NSArray *result = [self arrayFromCoreData:@"CNUser" predicate:predicate limitNum:1 offset:0 orderBy:nil];
    if (result == nil || result.count <= 0) {//不存在 则创建
        CNUser *user = (CNUser *)[self insertIntoCoreData:@"CNUser"];
        user.user_id = [phoneStr longLongValue];
        user.user_identity = UserIdentityNormal;
        user.user_name = phoneStr;
        user.user_phone = phoneStr;
        user.user_password = @"";
        user.user_sex = UserSexMan;
        user.has_chatMessages = nil;
        return user;
    }
    return (CNUser *)result[0];
}

- (CNUser *)lastLoginUser {
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"last_time" ascending:NO]];
    NSArray *result = [self arrayFromCoreData:@"CNUser" predicate:nil limitNum:1 offset:0 orderBy:sortDesc];
    if (result == nil || result.count <= 0)
        return nil;
    return (CNUser *)result[0];
}

@end
