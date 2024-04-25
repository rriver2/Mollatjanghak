//
//  ScholarshipBoxListActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import Foundation

actor ScholarshipBoxListActor {
    
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
    }
    
    struct Pageable: Decodable {
        let pageNumber: Int
    }
    
    // 전체 장학금 조회
    func fetchScholarshipBoxList(page: Int) async throws -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        
        do {
            let parameter = "page=\(page)"
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships?", parameter: parameter)
            
            return try responseHandling(data, response)
        } catch {
            throw error
        }
    }
    
    // 맞춤 장학금 조회
    func fetchCustomScholarshipBoxList(page: Int) async throws -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        
        do {
            let parameter = "page=\(page)"
            let userId = HTTPUtils.getDeviceUUID()
            print("userId", userId)
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships/members/\(userId)?", parameter: parameter)
            
            return try responseHandling(data, response)
        } catch {
            throw error
        }
    }
    
    // 검색 장학금 조회
    func fetchSearchScholarshipBoxList(page: Int, keyword: String) async throws -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        
        do {
            let parameter = "page=\(page)&keyword=\(keyword)"
            let (data , response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships?", parameter: parameter)
            
            return try responseHandling(data, response)
        } catch {
            throw error
        }
    }
}

extension ScholarshipBoxListActor {
    private func responseHandling(_ data: Data, _ response: HTTPURLResponse) throws  -> (ScholarshipBoxList: [ScholarshipBox], totalElements: Int, pageNumber: Int, totalPages: Int) {
        do {
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
                
                return (returnEntity, entity.totalElements, entity.pageable.pageNumber, entity.totalPages)
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
