//
//  ResetInfoActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import Foundation

actor ResetInfoActor {
    //FIXME: 수정 필요
    func clearUserInfo() async throws {
        do {
            let userId = HTTPUtils.getDeviceUUID()
            let (_ , response) = try await HTTPUtils.deleteURL(urlBack: "/api/members/\(userId)")
            
            switch response.statusCode {
            case 204:
                return
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
