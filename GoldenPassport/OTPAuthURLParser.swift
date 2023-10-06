//
//  OTPAuthURLParser.swift
//  GoldenPassport
//
//  Created by StanZhai on 2017/2/26.
//  Copyright © 2017年 StanZhai. All rights reserved.
//

import Foundation

class OTPAuthURLParser {
    var protocal: String
    var user: String?
    var host: String
    var secret: String
    var digits: UInt
    
    init?(_ otpAuthURL: String) {
        // otpauth://totp/user@host?secret=DA82347xxx&issuer=xxx
        // otpauth://totp/host?secret=ABCDEFG
        if let url = URL(string: otpAuthURL) {
            protocal = url.host!
            
            let pathComponent = url.lastPathComponent
            
            let parts = pathComponent.components(separatedBy: "@")
            
            if (parts.count > 1) {
                user = parts.first!
                host = parts.last!
            } else {
                host = parts.first!
            }
            
            let _secret = url.query!.components(separatedBy: "&").filter({ (component) -> Bool in
                return component.hasPrefix("secret=")
            }).first
            if _secret != nil {
                secret = _secret!.components(separatedBy: "=")[1]
            } else {
                secret = ""
            }
            
            let _digits = url.query!.components(separatedBy: "&").filter({ (component) -> Bool in
                return component.hasPrefix("digits=")
            }).first
            if _digits != nil {
                digits = UInt(_digits!.components(separatedBy: "=")[1])!
            } else {
                digits = TOTPGenerator.defaultDigits()
            }
        } else {
            return nil
        }
    }
}
