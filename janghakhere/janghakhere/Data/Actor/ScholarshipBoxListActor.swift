//
//  ScholarshipBoxListActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import Foundation

enum ScholarshipBoxListFliteringCategory {
    case deadline
    case inquiryCount
}

actor ScholarshipBoxListActor {
    

    //FIXME
    
    // 전체 장학금 조회
    func fetchScholarshipBoxList(_ category: ScholarshipBoxListFliteringCategory, page: Int) async throws -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        
        do {
            var parameter = ""
            switch category {
            case .deadline:
                parameter = "page=\(page)&deadline=true"
            case .inquiryCount:
                parameter = "page=\(page)"
            }
//            guard let userID = getUserID() else { throw URLError(.unknown) }
            
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships?memberId=testId&", parameter: parameter)
            
            return try MyScholarshopBoxListManager.responseHandling(data, response)
        } catch {
            throw error
        }
    }
    
    // 맞춤 장학금 조회
    func fetchCustomScholarshipBoxList(_ category: ScholarshipBoxListFliteringCategory, page: Int) async throws -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        
        do {
            var parameter = ""
            switch category {
            case .deadline:
                parameter = "page=\(page)&deadline=true"
            case .inquiryCount:
                parameter = "page=\(page)"
            }
            guard let userID = getUserID() else { throw URLError(.unknown) }
            
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships/members/\(userID)?", parameter: parameter)
            
            return try MyScholarshopBoxListManager.responseHandling(data, response)
        } catch {
            throw error
        }
    }
    
    // 검색 장학금 조회
    func fetchSearchScholarshipBoxList(page: Int, keyword: String) async throws -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        
        do {
            let parameter = "page=\(page)&keyword=\(keyword)&deadline=true"
            
            guard let userID = getUserID() else { throw URLError(.unknown) }
            
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships?memberId=\(userID)&", parameter: parameter)
            
            return try MyScholarshopBoxListManager.responseHandling(data, response)
        } catch {
            throw error
        }
    }
}

extension ScholarshipBoxListActor {
    private func getUserID() -> String? {
        //FIXME: "testId" 삭제하기
        return UserDefaults.getValueFromDevice(key: .userName, String.self) ?? "testId"
    }
}
