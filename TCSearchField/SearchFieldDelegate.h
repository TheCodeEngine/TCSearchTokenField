//
//  SearchFieldDelegate.h
//  SearchTokenField
//
//  Created by Konstantin Stoldt on 09.08.13.
//  Copyright (c) 2013 TheCodeEngine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchFieldDelegate <NSObject>
- (void)searchFieldDelegateTags:(NSMutableArray *)tagStringArray lists:(NSMutableArray *)listsStringArray otherToken:(NSMutableArray *)otherToken;
@optional
- (void)searchFieldDelegateTextDidChance;
@end
