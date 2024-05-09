//
//  DetailScholarshipActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/21/24.
//

import Foundation

struct DetailScholarshipContent: Decodable {
    let id: Int
    let viewCount: Int?
    let organization: String?
    let productName: String?
    let organizationType: String?
    let scholarshipType: String?
    let universityCategory: String?
    let grade: String?
    let majorCategory: String?
    let gradeDetails: String?
    let incomeDetails: String?
    let supportDetails: String?
    let specificQualificationDetails: String?
    let localResidencyDetails: String?
    let selectionMethodDetails: String?
    let selectionCountDetails: String?
    let eligibilityRestrictionDetails: String?
    let recommendationRequiredDetails: String?
    let requiredDocumentDetails: String?
    let homePageUrl: String?
    let startDate: String?
    let endDate: String?
    let applyingStatus: String?
}

actor DetailScholarshipActor {
    
    func fetchDetailScholarship(_ id: String) async throws -> DetailScholarshipContent {
        do {
            let (data, response) = try await HTTPUtils.getURL(urlBack: "/api/scholarships/", parameter: id)
            return try responseHandling(data, response)
        } catch {
            throw error
        }
    }
}

extension DetailScholarshipActor {
    
    private func responseHandling(_ data: Data, _ response: HTTPURLResponse) throws  -> DetailScholarshipContent {
        do {
            switch response.statusCode {
            case 200:
                guard let decodedData = try? JSONDecoder().decode(DetailScholarshipContent.self, from: data) else { throw URLError(.badServerResponse) }
                return decodedData
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
