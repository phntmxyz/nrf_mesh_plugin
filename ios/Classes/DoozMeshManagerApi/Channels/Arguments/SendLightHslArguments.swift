//
//  SendLightHslArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 02/08/2021.
//

struct SendLightHslArguments: BaseFlutterArguments {
    let address: UInt16
    let lightness: UInt16
    let keyIndex: Int
    let hue: UInt16
    let saturation: UInt16
    let sequenceNumber: Int
}
