//
//  SHURUitls.swift
//  Saihub
//
//  Created by 周松 on 2022/2/17.
//

import Foundation
import URKit
import UIKit
import SwiftUI

func makeBytesUR(_ data: Data) -> UR {
    let cbor = CBOR.byteString(data.bytes).cborEncode().data
    return try! UR(type: "crypto-psbt", cbor: cbor)
}

// MARK: 解析UR:Bytes
func parseUrBytesCoordinationSetup(_ urString: String) -> (text: String?, error: String?) {
    
    guard let ur = try? UR(urString: urString), let decodedCbor = try? CBOR.decode(ur.cbor.bytes),
    case let CBOR.byteString(byte) = decodedCbor,
    
    let text = String(bytes: Data(byte), encoding: .utf8) else {
        return (nil, "Unable to decode the QR code into a text file.")
    }
    print("zhaohong:\(text)")
    return (text, nil)
}

// MARK: 解析ur:crypto-psbt
func psbtUrToBase64Text(text: String) -> String {
    let decoder = URDecoder()

    if text.lowercased().hasPrefix("ur:crypto-psbt") {
        
        decoder.receivePart(text.lowercased())
        
        guard decoder.result == nil else {
            guard let result = try? decoder.result?.get() else { return ""}

            guard let decodedCbor = try? CBOR.decode(result.cbor.bytes),
                case let CBOR.byteString(bytes) = decodedCbor else {
                    return ""
            }
            
            return Data(bytes).base64EncodedString()

        }
        
    }
    
    return ""
}

extension String {
    var utf8: Data {
        return data(using: .utf8)!
    }
}



