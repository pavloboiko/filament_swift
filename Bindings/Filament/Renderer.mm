//
//  Renderer.mm
//  
//
//  Created by Stef Tervelde on 29.06.22.
//

#import "Bindings/Filament/Renderer.h"
#import <backend/PixelBufferDescriptor.h>
#import <filament/Renderer.h>
#import <filament/Texture.h>
#import <filament/Viewport.h>
#import "../Math.h"

@implementation ClearOptions
@end

@implementation DisplayInfo
@end

@implementation FrameRateOptions
@end

@implementation Renderer{
    filament::Renderer* nativeRenderer;
}

- (id) init:(void *)renderer{
    self->_renderer = renderer;
    self->nativeRenderer = (filament::Renderer*) renderer;
    return self;
}

- (void)setDisplayInfo:(DisplayInfo *) displayInfo{
    auto info = filament::Renderer::DisplayInfo();
    info.refreshRate = displayInfo.refreshRate;
    nativeRenderer->setDisplayInfo(info);
}
- (void)setFrameRateOptions:(FrameRateOptions *)options{
    auto info = filament::Renderer::FrameRateOptions();
    info.interval = options.interval;
    info.headRoomRatio = options.headRoomRatio;
    info.history = options.history;
    info.scaleRate = options.scaleRate;
    nativeRenderer->setFrameRateOptions(info);
}
- (void)setClearOptions:(ClearOptions *)info{
    auto options = filament::Renderer::ClearOptions();
    options.clear = info.clear;
    auto color = info.clearColor;
    options.clearColor = filament::math::float4(color.red, color.green, color.blue, color.alpha);
    options.discard = info.discard;
    nativeRenderer->setClearOptions(options);
}
- (void)setPresentationTime:(long)monotonicClockNanos{
    nativeRenderer->setPresentationTime(monotonicClockNanos);
}
- (bool)beginFrame:(SwapChain *)swapChain{
    return nativeRenderer->beginFrame( (filament::SwapChain*) swapChain.swapchain);
}
- (void)endFrame{
    nativeRenderer->endFrame();
}
- (void)render:(View *)view{
    nativeRenderer->render( (filament::View*) view.view);
}
- (void)renderStandaloneView:(View *)view{
    nativeRenderer->renderStandaloneView( (filament::View*) view.view);
}
- (void)copyFrame:(SwapChain *)dstSwapChain :(Viewport)dstViewport :(Viewport)srcViewport :(int)flags{
    nativeRenderer->copyFrame((filament::SwapChain*) dstSwapChain.swapchain, filament::Viewport(dstViewport.left, dstViewport.bottom, dstViewport.width, dstViewport.height), filament::Viewport(srcViewport.left, srcViewport.bottom, srcViewport.width, srcViewport.height));
}
- (NSData *)readPixels:(int)xoffset :(int)yoffset :(int)width :(int)height{
    // Calculate the buffer size (RGBA format)
     size_t bufferSize = width * height * 4;
     
     // Allocate buffer with correct alignment
     void* buffer = malloc(bufferSize);
     if (buffer == NULL) {
         NSLog(@"Failed to allocate memory for pixel buffer.");
         return nil;
     }
     
     // Initialize PixelBufferDescriptor
     filament::backend::PixelBufferDescriptor pixelBufferDescriptor(
         buffer, bufferSize,
         filament::backend::PixelDataFormat::RGBA,
         filament::backend::PixelDataType::UBYTE,
         [](void* buffer, size_t size, void* user) {
             free(buffer);
         },
         nullptr
     );
     
     // Read the pixels from the renderer
     nativeRenderer->readPixels(xoffset, yoffset, width, height, std::move(pixelBufferDescriptor));
     
     // Create NSData from buffer
     NSData *data = [[NSData alloc] initWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
     
     // Check the data length
     NSLog(@"Captured data length: %lu", (unsigned long)data.length);
     
     // Log some of the data to ensure it's being populated
     NSData *sampleData = [data subdataWithRange:NSMakeRange(0, MIN(16, data.length))];
     NSLog(@"Sample data: %@", [sampleData description]);
     
     return data;
}
- (NSData *)readPixels:(RenderTarget *)target :(int)xoffset :(int)yoffset :(int)width :(int)height{
    auto buf = filament::backend::PixelBufferDescriptor();
    nativeRenderer->readPixels((filament::RenderTarget*)target.target ,xoffset, yoffset, width, height, std::move(buf));
    return [[NSData alloc] initWithBytes:buf.buffer length:buf.size];
}

- (double)getUserTime{
    return nativeRenderer->getUserTime();
}
- (void)resetUserTime{
    nativeRenderer->resetUserTime();
}

@end
