//
//  SHWalletUtils.swift
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

import Foundation
import web3swift
import BigInt

@objc public class SHWalletUtils : NSObject {
    /// MARK -- 单位转换 有低位转高位 小数变大数
    @objc public static func coin_lowTohigh(amount : String, decimal : Int) -> String {
        guard amount.count != 0 else {
            return "0"
        }
        let leftNum = NSDecimalNumber.init(string: amount) as NSDecimalNumber
        var multiple = "1"
        for _ in 0..<decimal {
            multiple.append("0")
        }
        let rightNum = NSDecimalNumber.init(string: multiple) as NSDecimalNumber
        return leftNum.multiplying(by: rightNum).stringValue
    }
    /// MARK -- 单位转换 由大数转小数
    @objc public static func coin_highToLow(amount : String, decimal : Int) -> String {
        guard amount.count != 0 else {
            return "0"
        }
        let leftNum = NSDecimalNumber.init(string: amount) as NSDecimalNumber
        var multiple = "1"
        for _ in 0..<decimal {
            multiple.append("0")
        }
        let rightNum = NSDecimalNumber.init(string: multiple) as NSDecimalNumber
        return leftNum.dividing(by: rightNum).stringValue
    }
    ///MARK -- 单位转换 高位向低位转换 例如 ETH转Wei,小数变大数
    @objc public static func coin_convert(amount : String, decimal :Int ) -> String {
        let leftStr = NSString.convertDoubleStr(toIntStr: amount) as String
        guard let bigInt = Web3.Utils.parseToBigUInt(leftStr, decimals: 0) else { return "0" }
        return Web3.Utils.formatToPrecision(bigInt, numberDecimals: decimal, formattingDecimals: 8, decimalSeparator: ".", fallbackToScientific: false) ?? "0"
    }
    ///MARK -- 两个数相乘
    @objc public static func coin_multiplying(amount : String,count : String) -> String {
        if Double(amount) == nil || Double(count) == nil {
            return "0"
        }
        let num = NSDecimalNumber.init(string: amount).multiplying(by: NSDecimalNumber.init(string: count))
        return num.stringValue
    }
    ///将btc 转成sat
    @objc public static func coin_btcConvertSat(str : String) -> String {
        guard str.count != 0 else {
            return "0"
        }
        let bigInt = Web3.Utils.parseToBigUInt(str, decimals: 8)!
        return eth_convert(bigInt: bigInt)
    }
    ///将bigInt转成字符串
    public static func eth_convert(bigInt : BigUInt) -> String {
        return Web3.Utils.formatToPrecision(bigInt, numberDecimals: 0, formattingDecimals: 0, decimalSeparator: ".", fallbackToScientific: false) ?? ""
    }
}
