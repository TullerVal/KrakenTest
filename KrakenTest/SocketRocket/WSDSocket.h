//
//  WSDSocket.h
//  WebSocket Demo
//
//  Created by Chris Leversuch on 27/03/2015.
//  Copyright (c) 2015 Brightec. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WSDSocket;


@protocol WSDSocketDelegate <NSObject>
@optional
- (void)socketDidOpen:(WSDSocket *)socket;
- (void)socket:(WSDSocket *)socket didReceiveMessage:(NSString *)message;
- (void)socket:(WSDSocket *)socket didFailWithError:(NSError *)error;
- (void)socket:(WSDSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
@end


@interface WSDSocket : NSObject
@property (weak, nonatomic) id<WSDSocketDelegate> delegate;

- (instancetype)initWithUrl:(NSString *)url;
- (void)open;
- (void)close;
- (BOOL)isConnectionOpen;
- (BOOL)sendString:(NSString *)string;

@end
