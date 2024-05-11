//
//  MyInformationActor.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import Foundation

actor MyInformationActor {
    
    func sendNewUserData(userData: UserDataMaximum) async throws {
        do {
            let (_, _) = try await HTTPUtils.postURL(
                postStruct: userData, urlBack: "/api/members"
            )
        } catch {
            throw error
        }
    }
}


