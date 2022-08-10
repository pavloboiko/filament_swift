//
//  TextureSampler.mm

//  Created by Stef Tervelde on 30.06.22.
//
#import "Bindings/Filament/TextureSampler.h"
#import <filament/TextureSampler.h>

@implementation TextureSampler{
    filament::TextureSampler* nativeSampler;
}

- (id) init:(void *)sampler{
    self->_sampler = sampler;
    self->nativeSampler = (filament::TextureSampler*)sampler;
    return self;
}
- (id)init{
    return [self init: new filament::TextureSampler()];
}

@end
