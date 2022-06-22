//
//  Date-fromISO.swift
//  Bookworm
//
//  Created by Omer Avital on 6/7/22.
//

import Foundation

extension Date {
    static func fromISOString(_ dateString: String) -> Date? {
        let isoDateFormatter = ISO8601DateFormatter()
        return isoDateFormatter.date(from: dateString)
    }
}
