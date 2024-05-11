//
//  ChangedStatusManagement.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/11/24.
//

import SwiftUI

final class ChangedStatusManagement: ObservableObject {
    @Published var changedStatus: [String: PublicAnnouncementStatusCategory] = [:]
    
    func addChangedStatus(id: String, status: PublicAnnouncementStatusCategory) {
        changedStatus[id] = status
    }
}
