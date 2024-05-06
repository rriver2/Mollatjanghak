//
//  MyScholarshopBoxListActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import Foundation

actor MyScholarshopBoxListActor {
    // 저장 공고, 지원 공고 조회
    func fetchScholarshipBoxList(_ category: MyScholarshipFilteringCategory) async throws -> [ScholarshipBox] {
        do {
            guard let userName = UserDefaults.getValueFromDevice(key: .userName, String.self) else { throw URLError(.badServerResponse) }
            var parameter = ""
            switch category {
            case .deadline:
                parameter = "deadline=true"
            case .recent:
                parameter = "recent=true"
            }
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships/stored/\(userName)?", parameter: parameter)
            
            let (scholarshipList, _, _, _) = try MyScholarshopBoxListManager.responseHandling(data, response)
            return scholarshipList
        } catch {
            throw error
        }
    }
}
