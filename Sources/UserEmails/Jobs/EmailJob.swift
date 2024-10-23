//
//  EmailJob.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Queues
import SMTPTool

struct EmailJob: AsyncJob {
	typealias Payload = EmailPayload
	
    private let logger = Logger(label: "reminders.emails")
	
    init() { }
	
    func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
        logger.info("Create email from \(context.appConfig.noReplyEmail) to \(payload.recipient.address) subject \(payload.subject)")
        let email = try? Email(
            from: EmailAddress(address: context.appConfig.noReplyEmail),
            to: [payload.recipient],
            subject: payload.subject,
            body: payload.content
        )
        logger.info("Send email to \(payload.recipient)")
        try await context
            .smtp()
            .send(email!) { message in
                logger.info("\(message)")
            }
    }
	
	func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
		// If you don't want to handle errors you can simply return. You can also omit this function entirely.
	}
}
