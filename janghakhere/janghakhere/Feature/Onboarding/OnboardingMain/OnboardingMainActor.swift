//
//  OnboardingMainActor.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import Foundation

actor OnboardingMainActor {
    /// 기본 온보딩이 종료될때 사용할 함수입니다.
    /// - Parameter userData: 기본 정보만이 들어있는 UserDataMinimum 구조체를 이용하여 통신합니다.
    func signInWithMinumumData(userData: UserDataMinimum) async throws {
        do {
            let (data, response) = try await HTTPUtils.postURL(postStruct: userData, urlBack: "/api/members")
            dump(data)
            dump(response)
        } catch {
            throw error
        }
    }
}

extension OnboardingMainActor {
    
    
    /// 임시로 만든 204가 제대로 찍히는 지 확인용 response 함수
    /// - Parameter response: HTTPURLResponse 객체
    /// - Returns: 현재 리턴값이 뭔지를 알아내서 String으로 알려주는 함수. 잘될경우 204가 나와야함
    private func responseHandling(_ response: HTTPURLResponse) throws  -> String {
        do {
            switch response.statusCode {
            case 204:
                return "204"
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
