//
//  ScholarshipStatusActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

actor ScholarshipStatusActor {
    
    struct scholarship: Encodable {
        let id: String
        let status: String
    }
    
    // 장학금 지원 status 추가/수정
    func postScholarshipStatus(id: String, status: String) async throws {
        do {
            let postStruct = scholarship(id: id, status: status)
            
            guard let userID = UserDateActor.getUserID() else { throw URLError(.unknown) }
            
            let (_, response) = try await HTTPUtils.postURL(postStruct: postStruct, urlBack: "/api/scholarships/\(id)/members/\(userID)/\(status)")
            
            switch response.statusCode {
            case 200:
                print("성공")
            default: // 기술적 문제
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
    
    // 장학금 지원 status 삭제
    func deleteScholarshipStatus(id: String) async throws {
        do {
            guard let userID = UserDateActor.getUserID() else { throw URLError(.unknown) }
            
            let (_, response) = try await HTTPUtils.deleteURL(urlBack: "/api/scholarships/\(id)/members/\(userID)/stored")
            
            switch response.statusCode {
            case 200:
                print("성공")
            default: // 기술적 문제
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
