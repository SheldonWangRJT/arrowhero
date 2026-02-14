//
//  SpinComponent.swift
//  arrowhero
//
//  Created by Xiaodan Wang on 2/13/26.
//

import RealityKit

/// A component that spins the entity around a given axis.
struct SpinComponent: Component {
    let spinAxis: SIMD3<Float> = [0, 1, 0]
}
