//
//  EmailPayload.swift
//  RemindersMacOS.Emails
//
//  Created by Thomas Benninghaus on 21.10.24.
//

import SMTPTool

struct EmailPayload: Codable {
	let templateName: String
	let recipient: EmailAddress
	let subject: String
	let content: String
	
	init(to recipient: EmailAddress, subject: String, content: String, templateName: String) {
		self.recipient = recipient
		self.subject = subject
		self.content = content
		self.templateName = templateName
	}
}
