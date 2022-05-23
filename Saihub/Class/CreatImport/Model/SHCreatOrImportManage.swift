//
//  SHCreatOrImportManage.swift
//  Saihub
//
//  Created by macbook on 2022/3/2.
//

import Foundation
import web3swift
import SwiftUI
@objcMembers public class SHCreatOrImportManage : NSObject {
    @objc enum CreatOrImportError: Int, LocalizedError {
        case invalidPassword
        case invalidPrivateKey
        case invalidKeystore
        case invalidMnemonic
        case accountAlreadyExists
        case accountNotFound
        case failedToDeleteAccount
        case failedToUpdatePassword
        case failedToSaveKeystore
        case unknown
        
        var errorDescription: String? {
            return "WalletManager.Error.\(rawValue)"
        }
    }
    /**
     BTC创建助记词
     
     @param block 创建成功回调
     */
    @objc public static func creatBTCMnemonic(entropy:Data) throws-> String {
        let mnemonic = ZHMnemonic.create(entropy: entropy)
        return mnemonic;
    }
    /**
     解析ur:bytes
     
     @param block 创建成功回调
     */
    @objc public static func parsingUrBytes(qrstring:String) throws-> String {
        let (text, _) = parseUrBytesCoordinationSetup(qrstring)
        return text!;
    }
    /**
     BTC创建钱包
     
     @param pwd 密码
     @param block 创建成功回调
     */
    @objc public static func creatBTCAdressOrPriveKeyWallet(mnemonics:String ,passphrase:String ,index: UInt32) throws-> Dictionary<String, String> {
        let seed = BIP39.seedFromMmemonics(mnemonics, password: passphrase, language: .english)
        let zhWallet = ZHWallet(seed: seed!, network: .main)
        let firstAddress84Address = zhWallet.generateAddressBIP84(at: index)
        let firstAddress49Address = zhWallet.generateAddressBIP49(at: index)
        let changeAddress84Address = zhWallet.generateChangeAddressBIP84(at: index)
        let changeAddress49Address = zhWallet.generateChangeAddressBIP49(at: index)
        return ["firstAddress84Address" : firstAddress84Address, "firstAddress49Address" : firstAddress49Address,"changeAddress84Address" : changeAddress84Address, "changeAddress49Address" : changeAddress49Address];
    }
    /**
     BTC创建钱包public
     
     @param pwd 密码
     @param block 创建成功回调
     */
    @objc public static func creatBTCAdressWithPublicWallet(publicKey:String ,index: UInt32) throws-> Dictionary<String, String> {
        let network = Network.main
        var firstAddressAddress = ""
        var firstChangeAddress = ""
        if publicKey.prefix(4).lowercased().contains("xpub") {
            let textPublicKey = try!ZHPublicKey(xpub: publicKey, network: network)
            let  normalPub = try textPublicKey.derived(path: 0, index: index)
            let  changePub = try textPublicKey.derived(path: 1, index: index)
            firstAddressAddress = normalPub.address
            firstChangeAddress = changePub.address
        }else if publicKey.prefix(4).lowercased().contains("ypub") {
            let textPublicKey = try!ZHPublicKey(ypub: publicKey, network: network)
            let  normalPub = try textPublicKey.derived(path: 0, index: index)
            let  changePub = try textPublicKey.derived(path: 1, index: index)
            firstAddressAddress = normalPub.addressBIP49
            firstChangeAddress = changePub.addressBIP49
        }else if publicKey.prefix(4).lowercased().contains("zpub") {
            let textPublicKey = try! ZHPublicKey(zpub: publicKey, network: network)
            let  normalPub = try textPublicKey.derived(path: 0, index: index)
            let  changePub = try textPublicKey.derived(path: 1, index: index)
            firstAddressAddress = normalPub.addressBIP84
            firstChangeAddress = changePub.addressBIP84
        }
        return ["firstAddressAddress" : firstAddressAddress,"firstChangeAddress" : firstChangeAddress];
    }
    /**
     助记词数组
     
     @param pwd 密码
     @param block 创建成功回调
     */
    @objc public static func backMnemonicArray() throws-> Array<Any> {
        let wordList = WordList.english.words
        return wordList;
    }
}
