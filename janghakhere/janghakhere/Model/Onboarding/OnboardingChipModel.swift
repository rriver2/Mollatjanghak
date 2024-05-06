//
//  OnboardingChip.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/4/24.
//

import Foundation

class OnboardingChipModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var isSelected: Bool
    var title: String
    init(isSelected: Bool, title: String) {
        self.isSelected = isSelected
        self.title = title
    }
}
