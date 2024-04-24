//
//  AllScholarshipActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

actor AllScholarshipActor {
    func fetchDetailScholarship(id: String) async throws -> DetailScholarship {
        //FIXME: 실제 데이터로 채워야 함
        return DetailScholarship.mockData
    }
}
