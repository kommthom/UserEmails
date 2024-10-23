//
//  QueueContext+Services.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Queues
import Fluent
import SMTPTool

extension QueueContext {
    var db: Database {
        application.databases
            .database(logger: self.logger, on: self.eventLoop)!
    }
    
    func smtp() -> SMTPProviderProtocol {
        application.smtp(eventLoop: self.eventLoop)
    }
    
    var appConfig: AppConfig {
        application.config
    }
}
