//
//  MyScholarshipBoxListActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

struct MyScholarshipBoxContent: Decodable {
    let id: Int
    let organization: String
    let productName: String
    let supportDetails: String?
    let startDate: String?
    let endDate: String?
    let applyingStatus: String
    let storedDate: Date
}

actor MyScholarshipBoxListActor {
    @AppStorage("userData") private var userData: Data?
    
    // 저장 공고, 지원 공고 조회
    func fetchScholarshipBoxList(_ category: MyScholarshipFilteringCategory) async throws -> [ScholarshipBox] {
        do {
            guard let userID = getUserID() else { throw URLError(.unknown) }
            var parameter = ""
            switch category {
            case .deadline:
                parameter = "?deadline=true"
            case .recent:
                parameter = "?recent=true"
            }
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships/members/\(userID)/stored", parameter: parameter)
            
            let scholarshipList = try responseHandling(data, response)
            
            print("scholarshipList", scholarshipList)
            return scholarshipList
        } catch {
            throw error
        }
    }
    
    private func responseHandling(_ data: Data, _ response: HTTPURLResponse) throws  -> [ScholarshipBox] {
        do {
            switch response.statusCode {
            case 200:
                guard let entityList = try? JSONDecoder().decode([MyScholarshipBoxContent].self, from: data) else {
                    throw URLError(.unknown) }
                
                var returnEntity: [ScholarshipBox] = []
                
                for entity in entityList {
                    let DDay = entity.endDate == nil ? nil : Date().calculationDday(endDateString: entity.endDate!)
                    
                    let scholarshipBox = ScholarshipBox(id: String(entity.id), sponsor: entity.organization, title: entity.productName, DDay: DDay, prize: entity.supportDetails ?? "", publicAnnouncementStatus: .nothing)
                    returnEntity.append(scholarshipBox)
                }
                
                return returnEntity
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}

extension MyScholarshipBoxListActor {
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

