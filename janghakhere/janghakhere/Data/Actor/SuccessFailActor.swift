//
//  SuccessFailActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

actor ScholarshipStatusActor {
    
    struct scholarship: Encodable {
        let id: Int
        let status: String
    }
    
    // 장학금 지원 status 추가/수정
    func postScholarshipStatus(id: Int, status: String) async throws -> Bool {
        do {
            let postStruct = scholarship(id: id, status: status)
            
            guard let userName = UserDefaults.getValueFromDevice(key: .userName, String.self) else { throw URLError(.badServerResponse) }
            
            let (_, response) = try await HTTPUtils.postURL(postStruct: postStruct, urlBack: "/api/scholarships/stored\(userName)")
            
            switch response.statusCode {
            case 200:
                return true
            default: // 기술적 문제
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
