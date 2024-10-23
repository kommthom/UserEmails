//
//  EmailBuilder.swift
//
//
//  Created by Thomas Benninghaus on 04.01.24.
//

import Vapor
import LeafKit
import Foundation
import enum UserDTOs.LanguageIdentifier
import SMTPTool

class EmailBuilder: EmailBuilderProtocol {
    private let application: Application
    private var templateData: [String : String]
//    private let localization: LocalizationProtocol
    private var language: LanguageIdentifier
    private var templateType: EmailTemplateType
    private var recipient: EmailAddress?
    
    required init(application: Application) throws {
		self.application = application
        self.templateData = .init()
//        self.localization = try application.localization.provide()
        self.language = .notSet
        self.templateType = .notSet
        self.recipient = nil
    }
    
    func setRecipient(recipientEmailAddress: EmailAddress) -> Self {
        recipient = recipientEmailAddress
        templateData["recipientName"] = recipientEmailAddress.name
        templateData["recipientEmail"] = recipientEmailAddress.address
        return self
    }
    
    private func verifyURL(for token: String) -> String {
		#"http://\#(application.config.frontendURL):\#(application.config.port)/api/auth/email-verification?token=\#(token)"#
    }
    
    func setVerifyUrl(for token: String) -> Self {
        templateData["verify_url"] = verifyURL(for: token)
        return self
    }
    
    private func resetPasswordURL(for token: String) -> String {
		#"http://\#(application.config.frontendURL):\#(application.config.port)/api/auth/reset-password?token=\#(token)"#
    }
    
    func setResetPasswordUrl(for token: String) -> Self {
        templateData["reset_url"] = resetPasswordURL(for: token)
        return self
    }
    
    func setLanguage(language: LanguageIdentifier) -> Self {
        self.language = language
		templateData["locale"] = language.identifier
        return self
    }
    
    func setEmailTemplate(template: EmailTemplateType) -> Self {
       self.templateType = template
       return self
    }
    
    private func loadTemplate(templateType: EmailTemplateType, language: LanguageIdentifier, templateData: [String: String]) async throws -> EmailPayload {
		application.logger.info( { "Start rendering \(application.directory.viewsDirectory)/\(templateType.templateName).leaf"}())
		let contentView: View = try await self.application.view.render("\(templateType.templateName).leaf", templateData)
		application.logger.info( { "\(String(buffer: contentView.data))" }())
		let subject = "test" //self.localization.localize("\(templateType.domain).subject", locale: language.identifier, interpolations: [:])
        return EmailPayload(to: self.recipient!, subject: subject, content: String(buffer: contentView.data), templateName: templateType.templateName)
    }
    
    private func validateBeforeBuild() throws {
        guard let _ = recipient else {
            throw EmailError.recipientNotSpecified
        }
        guard language != .notSet else {
            throw EmailError.languageNotSpecified
        }
        switch templateType {
        case .resetPasswordEmail:
            guard !(templateData["reset_url"]?.isEmpty ?? true) else {
                throw EmailError.interpolationsNotComplete
            }
        case .verificationEmail:
            guard !(templateData["verify_url"]?.isEmpty ?? true) else {
                throw EmailError.interpolationsNotComplete
            }
        case .notSet:
            throw EmailError.templateTypeNotSpecified
        }
    }
    
    func build() async throws -> EmailPayload {
        try validateBeforeBuild()
        return try await loadTemplate(templateType: templateType, language: language, templateData: templateData)
    }
}
