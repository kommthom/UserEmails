//
//  ResourcePaths.swift
//  
//
//  Created by Thomas Benninghaus on 15.01.24.
//

import Foundation

public struct ResourcePaths: Sendable {
    public static let defaultLocale: String = "en_US" //LocaleIdentifier = .en_GB //.code
    public static let defaultLanguage: String = "en" //LanguageIdentifier = .en //.code
    public static let defaultEmailTemplate: EmailTemplateType = .verificationEmail
    public static let localizationsPath: URL = {
        return Bundle.module.url(
            forResource: ResourcePaths.defaultLanguage,
            withExtension: "json",
            subdirectory: "Resources/Localizations"
        )!.deletingLastPathComponent()
        /*if
            let url = Bundle.module.url(
            forResource: ResourcePaths.defaultLanguage.code,
            withExtension: "json",
            subdirectory: "Resources/Localizations"
        ) {
            if FileManager.default.fileExists(atPath: url.path) {
                return url!.deletingLastPathComponent()
            } else {
                throw ResourcePathError.localizationNotFound("Invalid path for localization")
            }
        }
        throw ResourcePathError.localizationNotFound("Localization files are missing")*/
    }()
    public static let htmlTemplatesPath: URL = {
        Bundle.module.url(
            forResource: defaultEmailTemplate.templateName,
            withExtension: "html",
            subdirectory: "Resources/HTML"
        )!.deletingLastPathComponent()
        /*if let url = Bundle.module.url(
            forResource: defaultEmailTemplate.templateName,
            withExtension: "html",
            subdirectory: "Resources/HTML"
        ) {
            if FileManager.default.fileExists(atPath: url.path) {
                return url.deletingLastPathComponent()
            } else {
                //throw ResourcePathError.templatePathNotFound("Invalid path for html templates")
            }
        } else {
            //throw ResourcePathError.templatePathNotFound("Html template files are missing")
        }*/
    }()
    public static let leafTemplatesPath: URL = {
        Bundle.module.url(
            forResource: defaultEmailTemplate.templateName,
            withExtension: "leaf",
            subdirectory: "Resources/Views"
        )!.deletingLastPathComponent()
        /*if let url = Bundle.module.url(
            forResource: defaultEmailTemplate.templateName,
            withExtension: "leaf",
            subdirectory: "Resources/Views"
        ) {
            if FileManager.default.fileExists(atPath: url.path) {
                return url.deletingLastPathComponent()
            } else {
                //throw ResourcePathError.templatePathNotFound("Invalid path for leaf templates")
            }
        } else {
            //throw ResourcePathError.templatePathNotFound("Leaf template files are missing")
        }*/
    }()
}

