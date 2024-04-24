//
//  SearchScholarshipActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import Foundation

actor SearchScholarshipActor {
    
    struct ScholarshipAPI: Encodable {
        let page: Int
        let keyword: String
    }
    
    struct ScholarshipBoxEntity: Decodable {
        let content: [Content]
        let pageable: Pageable
        let last: Bool
        let totalElements: Int
    }
    
    struct Content: Decodable {
        let id: Int
        let organization: String
        let productName: String
        let supportDetails: String
        let endDate: String
    }
    
    struct Pageable: Decodable {
        let pageNumber: Int
    }
    
    func fetchScholarshipBoxList(page: Int, keyword: String) async throws -> [ScholarshipBox] {
        
        do {
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships?", parameter: "page=\(page)&keyword=\(keyword)")
            
            switch response.statusCode {
            case 200:
                
                guard let entity = try? JSONDecoder().decode(ScholarshipBoxEntity.self, from: data) else { throw URLError(.badServerResponse) }
                
                var returnEntity: [ScholarshipBox] = []
                
                let entityList = entity.content
                
                for entity in entityList {
                    let DDay = Date().calculationDday(endDateString: entity.endDate)
                    
                    let scholarshipBox = ScholarshipBox(id: String(entity.id), sponsor: entity.organization, title: entity.productName, DDay: DDay, prize: entity.supportDetails, publicAnnouncementStatus: .Nothing)
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
