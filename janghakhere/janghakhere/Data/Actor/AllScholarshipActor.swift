//
//  AllScholarshipActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

actor AllScholarshipActor {
    func fetchScholarshipList(_ category : ScholarshipCategory) async throws -> [ScholarshipBox] {
        //FIXME: 실제 데이터로 채워야 함
        var mockDataList: [ScholarshipBox] = []
        switch category {
        case .custom:
            for _ in 1...15 {
                let newScholarShip = ScholarshipBox.mockCustomData
                mockDataList.append(newScholarShip)
            }
        case .all:
            for _ in 1...10 {
                let newScholarShip = ScholarshipBox.mockAllData
                mockDataList.append(newScholarShip)
            }
        }
        
        return mockDataList
    }
    
    func fetchDetailScholarship(id: String) async throws -> DetailScholarship {
        //FIXME: 실제 데이터로 채워야 함
        return DetailScholarship.mockData
    }
}