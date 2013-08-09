//
//  SearchFieldController.h
//  SearchTokenField
//
//  Created by Konstantin Stoldt on 09.08.13.
//  Copyright (c) 2013 TheCodeEngine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchFieldDelegate.h"


/**
 *	Erstellt eine SearchBar
 *
 * Siehe auch den TokenFieldGuide von Apple
 * https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/TokenField_Guide/
 *
 */
@interface SearchFieldController : NSObject <NSTokenFieldCellDelegate, NSTokenFieldDelegate>

- (id)initWithTokenField:(NSTokenField *)tokenField;

@property (weak) id delegate;
@property (strong) NSTokenField *searchTokenField;
@property (strong) NSMutableArray *tags;
@property (strong) NSMutableArray *lists;

- (NSMutableArray *)tagsStringArray;
- (NSMutableArray *)listsStringArray;
- (NSMutableArray *)searchWord;

@end
