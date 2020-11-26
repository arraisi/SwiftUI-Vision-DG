//
//  ErrorResult.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/11/20.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(code: Int)
}
