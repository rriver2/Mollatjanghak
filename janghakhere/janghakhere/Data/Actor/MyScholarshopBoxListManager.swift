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
    let endDate: String
    let status: String
}

struct Pageable: Decodable {
    let pageNumber: Int
}

//FIXME: TEMP 삭제하기
struct ScholarshipBoxEntity_Temp: Decodable {
    let content: [Content_Temp]
    let pageable: Pageable
    let last: Bool
    let totalPages: Int
    let totalElements: Int
}

struct Content_Temp: Decodable {
    let id: Int
    let organization: String
    let productName: String
    let supportDetails: String
    let endDate: String
}

//MARK: - 핸들링
class MyScholarshopBoxListManager {
    static func responseHandling(_ data: Data, _ response: HTTPURLResponse) throws  -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        do {
            switch response.statusCode {
            case 200:
                
                guard let entity = try? JSONDecoder().decode(ScholarshipBoxEntity_Temp.self, from: data) else { throw URLError(.badServerResponse) }
                
                var returnEntity: [ScholarshipBox] = []
                
                let entityList = entity.content
                
                for entity in entityList {
                    let DDay = Date().calculationDday(endDateString: entity.endDate)
                    
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
