//
//  MyScholarshopBoxListManager.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

//MARK: - DTO
struct ScholarshipAPI: Encodable {
    let page: Int
    let keyword: String
}

struct ScholarshipBoxEntity: Decodable {
    let content: [Content]
    let pageable: Pageable
    let last: Bool
    let totalPages: Int
    let totalElements: Int
}

struct Content: Decodable {
    let id: Int
    let organization: String
    let productName: String
    let supportDetails: String
    let endDate: String?
    let applyingStatus: String
}

struct Pageable: Decodable {
    let pageNumber: Int
}

//MARK: - 핸들링
class MyScholarshopBoxListManager {
    static func responseHandling(_ data: Data, _ response: HTTPURLResponse) throws  -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        do {
            switch response.statusCode {
            case 200:
                
                guard let entity = try? JSONDecoder().decode(ScholarshipBoxEntity.self, from: data) else {
                    throw URLError(.unknown) }
                
                var returnEntity: [ScholarshipBox] = []
                
                let entityList = entity.content
                
                for entity in entityList {
                    let DDay = entity.endDate == nil ? nil : Date().calculationDday(endDateString: entity.endDate!)
                    
                    let scholarshipBox = ScholarshipBox(id: String(entity.id), sponsor: entity.organization, title: entity.productName, DDay: DDay, prize: entity.supportDetails, publicAnnouncementStatus: .nothing)
                    returnEntity.append(scholarshipBox)
                }
                
                return (returnEntity, entity.totalElements, entity.pageable.pageNumber, entity.totalPages)
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
