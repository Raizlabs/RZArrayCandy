//
//  NSArray+RZFunctionalContainers.m
//  RZFunctionalContainerTests
//
//  Created by Nick Donaldson on 5/28/14.

#import "NSArray+RZFunctionalContainers.h"

@implementation NSArray (RZFunctionalContainers)

- (NSArray *)rz_map:(RZFCArrayObjBlock)block
{
    NSParameterAssert(block);
    NSMutableArray *mapped = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id result = block(obj, idx, self);
        if ( result ) {
            [mapped addObject:result];
        }
    }];
    return [NSArray arrayWithArray:mapped];
}

- (NSArray *)rz_filter:(RZFCArrayBooleanBlock)block
{
    NSParameterAssert(block);
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( block(obj, idx, self) ) {
            [filtered addObject:obj];
        }
    }];
    return [NSArray arrayWithArray:filtered];
}

- (id)rz_reduce:(RZFCArrayReduceBlock)block
{
    return [self rz_reduce:block initial:nil];
}

- (id)rz_reduce:(RZFCArrayReduceBlock)block initial:(id)initial
{
    NSParameterAssert(block);
    __block id accumulator = initial;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       accumulator = block( accumulator, obj, idx, self );
    }];
    return accumulator;
}

- (NSArray *)rz_pick:(NSString *)keypath
{
    NSParameterAssert(keypath);
    return [self valueForKeyPath:keypath];
}

- (BOOL)rz_all:(RZFCArrayBooleanBlock)block
{
    NSParameterAssert(block);
    __block BOOL passes = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( !block(obj, idx, self) ) {
            *stop = YES;
            passes = NO;
        }
    }];
    return passes;
}

- (BOOL)rz_none:(RZFCArrayBooleanBlock)block
{
    NSParameterAssert(block);
    __block BOOL nonePass = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( block(obj, idx, self) ) {
            *stop = YES;
            nonePass = NO;
        }
    }];
    return nonePass;
}

- (NSArray *)rz_compacted
{
    return [self rz_filter:^BOOL(id obj, NSUInteger idx, NSArray *array) {
        return ![obj isEqual:[NSNull null]];
    }];
}

- (NSArray *)rz_reversed
{
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)rz_deduped
{
    return [[NSOrderedSet orderedSetWithArray:self] array];
}

- (NSNumber *)rz_sum
{
    return [self valueForKeyPath:@"@sum.self"];
}

- (NSNumber *)rz_average
{
    return [self valueForKeyPath:@"@avg.self"];
}

- (NSNumber *)rz_max
{
    return [self valueForKeyPath:@"@max.self"];
}

- (NSNumber *)rz_min
{
    return [self valueForKeyPath:@"@min.self"];
}

@end
