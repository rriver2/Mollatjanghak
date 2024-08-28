//
//  MyPageActor.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/30/24.
//

import Foundation

// MARK: - 아직 현재 뷰는 완성되지 않아서 중간에 만들다 말았음. 아예 새로 만드는게 빠를듯
struct CurrentUserScholarshipStatus: Decodable {
    let name: String
    let totalSupportedAmount: Int
    let appliedScholarshipCount: Int
    let passedScholarshipCount: Int
}

actor MyPageActor {
    
    /// 서버에서 유저의 데이터를 가져와서 보여주는 API
    /// - Parameter id: OnboardingMain에서 생성된 UUID
    func getCurrentStatus(id: String) async throws -> CurrentUserScholarshipStatus {
        do {
            let (data, response) = try await HTTPUtils.getURL(urlBack: "/api/members/\(id)/status", parameter: "")
            return try responseHandling(data, response)
        } catch {
            throw error
        }
    }
    
    func getData() async throws -> [String] {
        return []
    }
}

extension MyPageActor {
    
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
