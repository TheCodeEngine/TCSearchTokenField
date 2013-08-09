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
    NSButton *magButton;
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
    [completeToken addObject:substring];
    [self.tags enumerateObjectsUsingBlock:^(Tag *obj, NSUInteger idx, BOOL *stop) {
        [completeToken addObject:obj.title];
    }];
    [self.lists enumerateObjectsUsingBlock:^(List *obj, NSUInteger idx, BOOL *stop) {
        [completeToken addObject:obj.title];
    }];
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
    if ( representedObject.isTag )
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

- (NSMenu *)tokenField:(NSTokenField *)tokenField menuForRepresentedObject:(id)representedObject
{
    NSMenu *tokenMenu = [[NSMenu alloc] init];
    NSMenuItem *artistItem = [[NSMenuItem alloc] init];
    [artistItem setTitle:@"Test"];
    [tokenMenu addItem:artistItem];
    return tokenMenu;
}

@end
