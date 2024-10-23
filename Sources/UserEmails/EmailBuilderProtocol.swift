//
//  EmailBuilderProtocol.swift
//  
//
//  Created by Thomas Benninghaus on 09.01.24.
//

import Foundation
import Vapor
import SMTPTool
import enum UserDTOs.LanguageIdentifier

protocol EmailBuilderProtocol {
    init(application: Application) throws
    func setRecipient(recipientEmailAddress: EmailAddress) -> Self
    func setVerifyUrl(for token: String) -> Self
    func setResetPasswordUrl(for token: String) -> Self
    func setLanguage(language: LanguageIdentifier) -> Self
    func setEmailTemplate(template: EmailTemplateType) -> Self
    func build() async throws -> EmailPayload
}
