//
//  SearchScholarshipStatus.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import Foundation

enum SearchScholarshipStatus {
    case notSearchedYet
    case loading // 검색한 후
    case searchedWithData // 데이터가 있을 때
    case searchedNoData // 데이터가 없을 때
    case failed // 실패했을 때
}
