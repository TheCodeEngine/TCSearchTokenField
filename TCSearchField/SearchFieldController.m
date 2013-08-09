//
//  SearchFieldController.m
//  SearchTokenField
//
//  Created by Konstantin Stoldt on 09.08.13.
//  Copyright (c) 2013 TheCodeEngine. All rights reserved.
//

#import "SearchFieldController.h"
#import "Tag.h"
#import "List.h"

@interface RepresentedObject : NSObject
- (id)initWithString:(NSString *)string;
@property (strong) NSString *string;
@property BOOL isTag;
@property BOOL isList;
@property BOOL isSearchKey;
- (void)updateBoolTags:(NSMutableArray *)tags lists:(NSMutableArray *)lists;
@end
@implementation RepresentedObject
- (id)initWithString:(NSString *)string
{
    if ( self = [super init] )
    {
        _string = string;
        _isTag = NO;
        _isList = NO;
        _isSearchKey = YES;
    }
    return self;
}
- (void)updateBoolTags:(NSMutableArray *)tags lists:(NSMutableArray *)lists
{
    [tags enumerateObjectsUsingBlock:^(Tag *obj, NSUInteger idx, BOOL *stop) {
        if ( [obj.title isEqualToString:self.string] )
        {
            self.isTag = YES;
            self.isSearchKey = NO;
        }
    }];
    [lists enumerateObjectsUsingBlock:^(List *obj, NSUInteger idx, BOOL *stop) {
        if ( [obj.title isEqualToString:self.string] )
        {
            self.isList = YES;
            self.isSearchKey = NO;
        }
    }];
}
@end

// ##############################################################################################################

@implementation SearchFieldController
{
    NSMutableArray *tagsTokens;
    NSMutableArray *listsTokens;
    NSMutableArray *otherTokens;
}

- (id)initWithTokenField:(NSTokenField *)tokenField;
{
    self = [super init];
    if (self)
    {
        _searchTokenField = tokenField;
        _searchTokenField.delegate = self;
        _tags = [[NSMutableArray alloc] init];
        _lists = [[NSMutableArray alloc] init];
        tagsTokens = [[NSMutableArray alloc] init];
        listsTokens = [[NSMutableArray alloc] init];
        otherTokens = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(searchFieldDelegateTextDidChance)] )
    {
        [self.delegate searchFieldDelegateTextDidChance]; 
    }
}

#pragma mark - NSTokenField Delegate

- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex
{
    NSMutableArray *completeToken = [[NSMutableArray alloc] init];
    [self.tags enumerateObjectsUsingBlock:^(Tag *obj, NSUInteger idx, BOOL *stop) {
        NSString *objString = obj.title;
        if ( [objString length] > [substring length] )
        {
            objString = [objString substringToIndex:[substring length]];
        }
        if ( [[objString lowercaseString] isEqualToString:[substring lowercaseString]] )
        {
            [completeToken addObject:obj.title];
        }
    }];
    [self.lists enumerateObjectsUsingBlock:^(List *obj, NSUInteger idx, BOOL *stop) {
        NSString *objString = obj.title;
        if ( [objString length] > [substring length] )
        {
            objString = [objString substringToIndex:[substring length]];
        }
        if ( [[objString lowercaseString] isEqualToString:[substring lowercaseString]] )
        {
            [completeToken addObject:obj.title];
        }
    }];
    if ( [completeToken count] > 0 )
    {
        [completeToken insertObject:substring atIndex:0];
    }
    return completeToken;
}


- (id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString: (NSString *)editingString
{
    RepresentedObject *r = [[RepresentedObject alloc] initWithString:editingString];
    [r updateBoolTags:self.tags lists:self.lists];
    return r;
}

- (NSString *)tokenField:(NSTokenField *)tokenFieldArg displayStringForRepresentedObject:(RepresentedObject *)representedObject
{
    if ( representedObject.isTag && representedObject.isList )
    {
        return [NSString stringWithFormat:@"Both - %@", representedObject.string];
    }
    else if ( representedObject.isTag )
    {
        return [NSString stringWithFormat:@"Tag - %@", representedObject.string];
    }
    else if ( representedObject.isList )
    {
        return [NSString stringWithFormat:@"List - %@", representedObject.string];
    }
    else
    {
        return representedObject.string;
    }
}

- (BOOL)tokenField:(NSTokenField *)tokenField hasMenuForRepresentedObject:(RepresentedObject *)representedObject
{
    if ( representedObject.isList || representedObject.isTag )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSMenu *)tokenField:(NSTokenField *)tokenField menuForRepresentedObject:(RepresentedObject *)representedObject
{
    NSMenu *tokenMenu = [[NSMenu alloc] init];
    NSMenuItem *artistItem = [[NSMenuItem alloc] init];
    [artistItem setTitle:representedObject.string];
    [tokenMenu addItem:artistItem];
    return tokenMenu;
}

- (void)getElements
{
    [tagsTokens removeAllObjects]; [listsTokens removeAllObjects]; [otherTokens removeAllObjects];
    NSArray *searchTokens = [self.searchTokenField.stringValue componentsSeparatedByString:@","];
    [searchTokens enumerateObjectsUsingBlock:^(NSString *token, NSUInteger idx, BOOL *stop) {
        if ( [token hasPrefix:@"Tag - "] )
        {
            [tagsTokens addObject:[token stringByReplacingOccurrencesOfString:@"Tag - " withString:@""]];
        }
        else if ( [token hasPrefix:@"List - "] )
        {
            [listsTokens addObject:[token stringByReplacingOccurrencesOfString:@"List - " withString:@""]];
        }
        else if ( [token hasPrefix:@"Both - "] )
        {
            [tagsTokens addObject:[token stringByReplacingOccurrencesOfString:@"Both - " withString:@""]];
            [listsTokens addObject:[token stringByReplacingOccurrencesOfString:@"Both - " withString:@""]];
        }
        else
        {
            [otherTokens addObject:token];
        }
    }];
    if ( self.delegate && [self.delegate respondsToSelector:@selector(searchFieldDelegateTags:lists:otherToken:)] )
    {
        [self.delegate searchFieldDelegateTags:tagsTokens lists:listsTokens otherToken:otherTokens];
    }
}

@end
