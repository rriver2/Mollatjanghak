//
//  SuccessFailActor.swift
//  janghakhere
//
//  Created by Taehwan Kim on 8/28/24.
//

import Foundation

struct XXX: Decodable {
    let name: String
    let totalSupportedAmount: Int
    let appliedScholarshipCount: Int
    let passedScholarshipCount: Int
}

actor SuccessFailActor {
    ///  서버에 장학금 정보 전송. 아직 미완성
    /// - Parameter id: OnboardingMain에서 생성된 UUID
    func getCurrentStatus(id: String) async throws -> CurrentUserScholarshipStatus {
        do {
            let (data, response) = try await HTTPUtils.getURL(urlBack: "/api/members/\(id)/status", parameter: "")
            return try responseHandling(data, response)
        } catch {
            throw error
        }
    }
}


extension SuccessFailActor {
    
    private func responseHandling(_ data: Data, _ response: HTTPURLResponse) throws  -> CurrentUserScholarshipStatus {
        do {
            switch response.statusCode {
            case 200:
                guard let decodedData = try? JSONDecoder().decode(CurrentUserScholarshipStatus.self, from: data) else { throw URLError(.badServerResponse) }
                return decodedData
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
