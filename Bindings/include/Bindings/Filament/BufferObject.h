//
//  BufferObject.h
//  swift-gltf-viewer
//
//  Created by Stef Tervelde on 10.09.23.
//
#import <Foundation/Foundation.h>

#ifndef BufferObject_h
#define BufferObject_h

@interface BufferObject : NSObject

@property (nonatomic, readonly, nonnull) void* BufferObject  NS_SWIFT_UNAVAILABLE("Don't access the raw pointers");
- (nonnull id) init: (nonnull void*) BufferObject NS_SWIFT_UNAVAILABLE("Instances are created internally");
- (nonnull id) init NS_UNAVAILABLE;

@end


#endif /* BufferObject_h */
