//
//  EmailVerifier.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Queues
import UserModels
import SMTPTool

public struct EmailVerifier {
	public let emailTokenRepository: EmailTokenRepositoryProtocol
	public let config: AppConfig
	public let queue: Queue
	//public let eventLoop: EventLoop
	public let generator: RandomGenerator
	
	public func verify(for user: UserModel) async throws  {
		let token = generator.generate(bits: 256)
		let emailToken = try EmailToken(
			userID: user.requireID(),
			token: SHA256.hash(token)
		)
//		let verifyUrl = url(token: token)
		try? await emailTokenRepository
			.create(emailToken)
		
		let payload = try await EmailBuilder(application: self.queue.context.application)
						.setRecipient(recipientEmailAddress: EmailAddress(address: user.email, name: user.fullName))
						.setVerifyUrl(for: token)
						.setEmailTemplate(template: .verificationEmail)
						.setLanguage(language: user.locale.language.identifier)
						.build()
		try await self.queue.dispatch(
			EmailJob.self,
			payload
		)
	}
	
	private func url(token: String) -> String {
		#"\#(config.apiURL)/auth/email-verification?token=\#(token)"#
	}
}

extension Application {
	public var emailVerifier: EmailVerifier {
		.init(
			emailTokenRepository: self.repositories.emailTokens,
			config: self.config,
			queue: self.queues.queue,
			//eventLoop: eventLoopGroup.next(),
			generator: self.random
		)
	}
}

extension Request {
	public var emailVerifier: EmailVerifier {
		.init(
			emailTokenRepository: self.emailTokens,
			config: application.config,
			queue: self.queue,
			//eventLoop: eventLoop,
			generator: self.application.random
		)
	}
}
