//
//  FilamentAsset.mm

//  Created by Stef Tervelde on 30.06.22.
//
#import "Bindings/GLTFIO/FilamentAsset.h"
#import <gltfio/FilamentAsset.h>
#import <utils/Entity.h>

@implementation FilamentAsset{
    filament::gltfio::FilamentAsset* nativeAsset;
}

- (id) init:(void *)asset{
    self->_asset = asset;
    self->nativeAsset = (filament::gltfio::FilamentAsset*)asset;
    return self;
}
+ (NSArray<NSNumber*>*)getEntitiesArray: (const void*) array :(unsigned long)count{
    auto typedArray = (utils::Entity*) array;
    auto target = [[NSMutableArray alloc] initWithCapacity:count];
    for(auto i = 0; i<count; i++){
        auto ent = typedArray[i];
        auto num = utils::Entity::smuggle(ent);
        target[i] = [[NSNumber alloc] initWithUnsignedInt: num];
    }
    return target;
}
- (NSArray<NSNumber *> *)getEntities{
    auto ents = nativeAsset->getEntities();
    auto count = nativeAsset->getEntityCount();

    return [FilamentAsset getEntitiesArray:ents :count];
}
- (NSArray<NSNumber *> *)getLightEntities{
    auto ents = nativeAsset->getLightEntities();
    auto count = nativeAsset->getLightEntityCount();
    return [FilamentAsset getEntitiesArray:ents :count];
}
- (NSArray<NSNumber *> *)getRenderableEntities{
    auto ents = nativeAsset->getRenderableEntities();
    auto count = nativeAsset->getRenderableEntityCount();
    return [FilamentAsset getEntitiesArray:ents :count];
}
- (NSArray<NSNumber *> *)getCameraEntities{
    auto ents = nativeAsset->getCameraEntities();
    auto count = nativeAsset->getCameraEntityCount();
    return [FilamentAsset getEntitiesArray:ents :count];
}
- (Entity)getRoot{
    return utils::Entity::smuggle(nativeAsset->getRoot());
}
- (Entity)popRenderable{
    return utils::Entity::smuggle(nativeAsset->popRenderable());
}
- (size_t)popRenderables:(NSMutableArray<NSNumber *>*)entities{
    if(entities == nil){
        return nativeAsset->popRenderables(nil, 0);
    }
    utils::Entity ents[entities.count];
    for(auto i = 0; i<entities.count; i++){
        ents[i] = utils::Entity::import(entities[i].unsignedIntValue);
    }
    
    auto count = nativeAsset->popRenderables(ents, entities.count);
    for (auto j = 0; j<count; j++) {
        entities[j] = [NSNumber numberWithUnsignedInt:utils::Entity::smuggle(ents[j])];
    }
    return count;
    
}
- (NSArray<NSString*>*)getResourceUris{
    auto uris = nativeAsset->getResourceUris();
    auto count = nativeAsset->getResourceUriCount();
    auto result = [[NSMutableArray<NSString*> alloc] initWithCapacity:count];
    for(auto i = 0; i<count; i++){
        result[i] = [[NSString alloc] initWithUTF8String:uris[i]];
    }
    return result;
}
- (Box *)getBoundingBox{
#warning ("Implement")
}
- (NSString *)getName:(Entity)entity{
    auto name = nativeAsset->getName(utils::Entity::import(entity));
    return [[NSString alloc] initWithUTF8String:name];
}
- (Entity)getFirstEntityByName:(NSString *)name{
    auto entity = nativeAsset->getFirstEntityByName([name UTF8String]);
    return utils::Entity::smuggle(entity);
}
- (NSArray<NSNumber *> *)getEntitiesByName:(NSString *)name{
    auto count = nativeAsset->getEntitiesByName([name UTF8String], nil, 0);
    utils::Entity ents[count];
    nativeAsset->getEntitiesByName([name UTF8String], ents, count);
    return [FilamentAsset getEntitiesArray:ents :count];
}
- (NSArray<NSNumber *> *)getEntitiesByPrefix:(NSString *)name{
    auto count = nativeAsset->getEntitiesByPrefix([name UTF8String], nil, 0);
    utils::Entity ents[count];
    nativeAsset->getEntitiesByPrefix([name UTF8String], ents, count);
    return [FilamentAsset getEntitiesArray:ents :count];
}
- (NSString *)getExtras:(Entity)entity{
    auto name = nativeAsset->getExtras(utils::Entity::import(entity));
    if(name == nil){
        return nil;
    }
    return [[NSString alloc] initWithUTF8String:name];
}
@end
