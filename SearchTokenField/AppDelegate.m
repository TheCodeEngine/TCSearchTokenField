//
//  AppDelegate.m
//  SearchTokenField
//
//  Created by Konstantin Stoldt on 09.08.13.
//  Copyright (c) 2013 TheCodeEngine. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchFieldController.h"
#import "Tag.h"
#import "List.h"

@implementation AppDelegate
{
    SearchFieldController *searchFieldController;
    NSMutableArray *tags;
    NSMutableArray *lists;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    tags = [[NSMutableArray alloc] initWithArray:@[[[Tag alloc] initWithTitle:@"Tag 1"],
                                                   [[Tag alloc] initWithTitle:@"Tag 2"],
                                                   [[Tag alloc] initWithTitle:@"Tag 12"]
    ]];
    lists = [[NSMutableArray alloc] initWithArray:@[[[List alloc] initWithTitle:@"Inbox"],
                                                    [[List alloc] initWithTitle:@"Analysis"],
                                                    [[List alloc] initWithTitle:@"List 3"]
    ]];
    // Insert code here to initialize your application
    searchFieldController = [[SearchFieldController alloc] initWithTokenField:self.tokenField];
    searchFieldController.delegate = self;
    [searchFieldController.tags addObjectsFromArray:tags];
    [searchFieldController.lists addObjectsFromArray:lists];
}

- (IBAction)getSearchTokensAction:(id)sender
{
    [searchFieldController getElements];
}

#pragma mark - SearchField Delegate
- (void)searchFieldDelegateTextDidChance
{
    NSLog(@"Text SearchField Chance");
}
- (void)searchFieldDelegateTags:(NSMutableArray *)tagStringArray lists:(NSMutableArray *)listsStringArray otherToken:(NSMutableArray *)otherToken
{
    NSLog(@"Tokens:\n\tTags: %@\n\tLists: %@\n\tOther: %@", tagStringArray, listsStringArray, otherToken);
}

@end
