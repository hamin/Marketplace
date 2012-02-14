/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDRunLoopCondition.h"
#import "DDRunLoopPoker.h"

@implementation DDRunLoopCondition

- (id)initWithCondition:(NSInteger)condition onRunLoop:(NSRunLoop *)runLoop
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _poker = [[DDRunLoopPoker alloc] initWithRunLoop:runLoop];
    _condition = condition;
    
    return self;
}

- (id)initWithCondition:(NSInteger)condition
{
    return [self initWithCondition:condition onRunLoop:[NSRunLoop currentRunLoop]];
}

- (id)init
{
    return [self initWithCondition:0];
}

- (void)dealloc
{
    [self dispose];
    [super dealloc];
}

- (void)dispose
{
    [_poker dispose];
    _poker = nil;
}

- (NSInteger)condition
{
    return _condition;
}

- (void)setCondition:(NSInteger)condition
{
    _condition = condition;
}

- (void)waitForCondition:(NSInteger)condition
{
    [self waitForCondition:condition beforeDate:[NSDate distantFuture]];
}

- (BOOL)waitForCondition:(NSInteger)condition beforeDate:(NSDate *)endDate
{
    while(_condition != condition)
    {
        BOOL result = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                               beforeDate:endDate];
        NSAssert(result, @"Run loop should have run");
        if ([endDate timeIntervalSinceNow] <= 0)
        {
            return NO;
        }
    }
    return YES;
}

- (void)signalWithCondition:(NSInteger)condition
{
    _condition = condition;
    [_poker pokeRunLoop];
}

@end
