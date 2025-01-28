//
//  BaseFlutterArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

import Foundation

typealias FlutterCallArguments = [String : Any]

enum FlutterCallError: Error{
    case notImplemented
    case missingArguments
    case errorDecoding
}

// MARK: Base protocol for arguments
protocol BaseFlutterArguments: Decodable{
    init(_ arguments: FlutterCallArguments?) throws
}

extension BaseFlutterArguments{

    init(_ arguments: FlutterCallArguments?) throws {
        guard let _arguments = arguments else{
            throw FlutterCallError.missingArguments
        }
        do{
            print("arguments: \(_arguments)")
            let jsonData = try JSONSerialization.data(withJSONObject: _arguments)
            print("jsonData: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
            self = try JSONDecoder().decode(Self.self, from: jsonData)
        }catch{
            print("Decoding error: \(error)")
            throw FlutterCallError.errorDecoding
        }
    }
    
}
