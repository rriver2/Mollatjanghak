//
//  Utils.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/15/24.
//

import Foundation

struct Utils {
    static func getConfig<T>(key: String, type: T.Type) -> T? {
        return Bundle.main.infoDictionary?[key] as? T
    }
}
