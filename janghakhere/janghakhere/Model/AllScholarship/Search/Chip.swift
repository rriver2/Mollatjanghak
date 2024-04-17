//
//  Chip.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/17/24.
//

import Foundation

class Chip: ObservableObject, Identifiable {
    // TODO: 명시적 ID를 부여하기 위하여 UUID를 대체할 필요 존재. Search시 Date+UUID라던지?
    let id = UUID()
    let title: String
    
    init(title: String) {
        self.title = title
    }
}
