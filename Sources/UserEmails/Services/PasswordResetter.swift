//
//  PasswordResetter.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Queues
import UserModels
import SMTPTool

public struct PasswordResetter {
	public let queue: Queue
	public let repository: PasswordTokenRepositoryProtocol
	//public let eventLoop: EventLoop
	public let config: AppConfig
	public let generator: RandomGenerator
	
	/// Sends a email to the user with a reset-password URL
	public func reset(for user: UserModel) async throws {
		let token = generator.generate(bits: 256)
		let resetPasswordToken = try PasswordToken(userID: user.requireID(), token: SHA256.hash(token))
//		let url = resetURL(for: token)
		let payload = try await EmailBuilder(application: self.queue.context.application)
			.setRecipient(recipientEmailAddress: EmailAddress(address: user.email, name: user.fullName))
			.setResetPasswordUrl(for: token)
			.setEmailTemplate(template: .resetPasswordEmail)
			.setLanguage(language: user.locale.language.identifier)
			.build()
		try await repository.create(resetPasswordToken)
		try await self.queue.dispatch(EmailJob.self, payload)
	}
	
	private func resetURL(for token: String) -> String {
		"\(config.frontendURL)/auth/reset-password?token=\(token)"
	}
}

extension Request {
	public var passwordResetter: PasswordResetter {
		.init(
			queue: self.queue,
			repository: self.passwordTokens,
			//eventLoop: self.eventLoop,
			config: self.application.config,
			generator: self.application.random
		)
	}
}
