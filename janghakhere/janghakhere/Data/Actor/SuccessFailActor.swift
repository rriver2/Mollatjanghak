//
//  SuccessFailActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

actor ScholarshipStatusActor {
    @AppStorage("userData") private var userData: Data?
    
    struct scholarship: Encodable {
        let id: String
        let status: String
    }
    
    // 장학금 지원 status 추가/수정
    func postScholarshipStatus(id: String, status: String) async throws -> Bool {
        do {
            let postStruct = scholarship(id: id, status: status)
            
            guard let userID = getUserID() else { throw URLError(.unknown) }
            
            let (_, response) = try await HTTPUtils.postURL(postStruct: postStruct, urlBack: "/api/scholarships/\(id)/members/\(userID)/\(status)")
            
            switch response.statusCode {
            case 200:
                print("성공")
                return true
            default: // 기술적 문제
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}

extension ScholarshipStatusActor {
    private func getUserID() -> String? {
        if let data = userData {
            do {
                let decoder = JSONDecoder()
                let loadedUserData = try decoder.decode(UserData.self, from: data)
                
                return loadedUserData.id
            } catch {
                print("Failed to decode user data: \(error)")
                return nil
            }
        }
        return nil
    }
}
