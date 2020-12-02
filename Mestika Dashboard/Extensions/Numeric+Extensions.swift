//
//  Numeric+Extensions.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 02/12/20.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
