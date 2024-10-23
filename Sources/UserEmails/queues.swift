//
//  queues.swift
//  RemindersMacOS.BackEnd
//
//  Created by Thomas Benninghaus on 19.10.24.
//

import Vapor
import Queues
import QueuesRedisDriver

public func queues(_ app: Application) throws {
	app.logger.info("Configuring queues...")
	// MARK: Queues Configuration
	if app.environment != .testing {
		try app.queues
			.use(
				.redis(
					.init(
						url: Environment.get(EMailsConstants.REDIS_URL) ?? "redis://127.0.0.1:6379",
						pool: .init(
							connectionRetryTimeout: .seconds(60))
						)
					)
			)
	}
	// MARK: Jobs
	app.queues.add(EmailJob())
}
