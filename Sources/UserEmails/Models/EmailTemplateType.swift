//
//  EmailTemplateType.swift
//  
//
//  Created by Thomas Benninghaus on 09.01.24.
//

import Foundation

public enum EmailTemplateType: String, Identifiable, Codable, Sendable {
    case verificationEmail
    case resetPasswordEmail
    case notSet
    
    public var id: String {
        String(describing: self)
    }
    
    public var templateName: String {
        switch self {
        case .verificationEmail: return "VerificationEmailTemplate"
        case .resetPasswordEmail: return "ResetPasswordEmailTemplate"
        case .notSet: return ""
        }
    }
    
    public var domain: String {
        switch self {
        case .verificationEmail: return "verificationemail"
        case .resetPasswordEmail: return "resetpasswordemail"
        case .notSet: return ""
        }
    }
    
    public var url: String {
        switch self {
        case .verificationEmail: return "/auth/email-verification"
        case .resetPasswordEmail: return "/auth/reset-password"
        case .notSet: return ""
        }
    }
}
