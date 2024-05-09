//
//  UserDateActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/9/24.
//

import SwiftUI

actor UserDateActor {
    @AppStorage("userData") static var userData: Data?
    
    static func getUserID() -> String? {
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
