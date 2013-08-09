//
//  AppDelegate.h
//  SearchTokenField
//
//  Created by Konstantin Stoldt on 09.08.13.
//  Copyright (c) 2013 TheCodeEngine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SearchFieldDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, SearchFieldDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTokenField *tokenField;

@end
