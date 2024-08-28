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
    // Calculate the buffer size for RGBA (4 bytes per pixel)
    size_t bufferSize = width * height * 4;

    // Allocate memory for the pixel buffer
    void* buffer = malloc(bufferSize);
    if (buffer == NULL) {
        NSLog(@"Failed to allocate memory for pixel buffer.");
        return nil;
    }
    
    // Create a PixelBufferDescriptor
    filament::backend::PixelBufferDescriptor pixelBufferDescriptor(
        buffer, bufferSize,
        filament::backend::PixelDataFormat::RGBA,
        filament::backend::PixelDataType::UBYTE,
        [](void* buffer, size_t size, void* user) {
            // Free the buffer after use
            free(buffer);
        },
        nullptr // No additional user data
    );

    // Read the pixels into the buffer
    nativeRenderer->readPixels(xoffset, yoffset, width, height, std::move(pixelBufferDescriptor));

    // Convert the buffer to NSData
    NSData *data = [[NSData alloc] initWithBytes:buffer length:bufferSize];
    
    if (data.length != bufferSize) {
        NSLog(@"Error: The size of the NSData object does not match the expected buffer size.");
        return nil;
    }

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
