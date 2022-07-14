//
//  TransformManager.swift
//
//  Created by Stef Tervelde on 14.07.22.
//
import FilamentBindings

extension TransformManager{
    public func setTransform(_ instance: EntityInstance, _ localTransform: simd_float4x4){
        let cols = localTransform.columns
        let transform = simd_double4x4(columns: (
            simd_make_double4(Double(cols.0.x), Double(cols.0.y), Double(cols.0.z), Double(cols.0.w)),
            simd_make_double4(Double(cols.1.x), Double(cols.1.y), Double(cols.1.z), Double(cols.1.w)),
            simd_make_double4(Double(cols.2.x), Double(cols.2.y), Double(cols.2.z), Double(cols.2.w)),
            simd_make_double4(Double(cols.3.x), Double(cols.3.y), Double(cols.3.z), Double(cols.3.w))
        ))
        
        setTransform(instance, transform)
    }
}
