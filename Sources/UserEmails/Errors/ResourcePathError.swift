//
//  ResourcePathError.swift
//  RemindersMacOS.Emails
//
//  Created by Thomas Benninghaus on 21.10.24.
//

public enum ResourcePathError: Error {
	case localizationNotFound(String)
	case localizationNotReadable(String)
	case templatePathNotFound(String)
	case templatePathNotReadable(String)
}
