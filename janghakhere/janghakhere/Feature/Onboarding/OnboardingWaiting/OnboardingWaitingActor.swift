//
//  OnboardingWaitingActor.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/5/24.
//

import Foundation

struct UserGenerateStatus: Decodable {
    let done: Bool
    let count: Int
}

actor OnboardingWaitingActor {
    
    /// 기본 온보딩이 종료될때 사용할 함수입니다.
    /// - Parameter userData: 기본 정보만이 들어있는 UserDataMinimum 구조체를 이용하여 통신합니다.
    func signInWithMinumumData(userData: UserDataMinimum) async throws {
        do {
            let (_, _) = try await HTTPUtils.postURL(
                postStruct: userData, urlBack: "/api/members"
            )
        } catch {
            throw error
        }
    }
    
    /// 서버에서 맞춤화된 공고를 생성했는지 확인하는 api
    /// - Parameter id: OnboardingMain에서 생성된 UUID
    func getCompleteStatus(id: String) async throws -> UserGenerateStatus {
        do {
            let (data, response) = try await HTTPUtils.getURL(urlBack: "/api/members/\(id)/completed", parameter: "")
            return try responseHandling(data, response)
        } catch {
            throw error
        }
    }
}

extension OnboardingWaitingActor {
    
    private func responseHandling(_ data: Data, _ response: HTTPURLResponse) throws  -> UserGenerateStatus {
        do {
            switch response.statusCode {
            case 200:
                guard let decodedData = try? JSONDecoder().decode(UserGenerateStatus.self, from: data) else { throw URLError(.badServerResponse) }
                return decodedData
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}


