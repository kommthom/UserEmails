//
//  AppConfig.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

public struct AppConfig : Sendable{
	public let frontendURL: String
	public let port: String
	public let apiURL: String
	public let noReplyEmail: String
    
	public static var environment: AppConfig {
		guard
			let frontendURL = Environment.get(EMailsConstants.SITE_FRONTEND_URL) else {
			fatalError("Please add 'SITE_FRONTEND_URL' to environment variables")
		}
        guard
			let port = Environment.get(EMailsConstants.SITE_FRONTEND_PORT)
        else {
            fatalError("Please add 'SITE_FRONTEND_URL' to environment variables")
        }
		guard let apiURL = Environment.get(EMailsConstants.SITE_API_URL) else {
			fatalError("Please add 'SITE_API_URL' to environment variables")
		}
		guard let noReplyEmail = Environment.get(EMailsConstants.NO_REPLY_EMAIL)
			else {
				fatalError("Please add 'NO_REPLY_EMAIL' to environment variables")
		}
		return .init(frontendURL: frontendURL, port: port, apiURL: apiURL, noReplyEmail: noReplyEmail)
    }
}

extension Application {
	public struct AppConfigKey: StorageKey {
        public typealias Value = AppConfig
    }
    
	public var config: AppConfig {
        get {
            storage[AppConfigKey.self] ?? .environment
        }
        set {
            storage[AppConfigKey.self] = newValue
        }
    }
}
