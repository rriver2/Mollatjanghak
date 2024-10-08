//
//  PathType.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

enum PathType: Hashable {
    case detailScholarshipView(id: String, status: PublicAnnouncementStatusCategory)
    case searchScholarshipView
    case onboardingBeginView
    case onboardingMainView
    case onboardingWaitingView(userData: UserDataMinimum)
    case onboardingCompleteView(count: Int)
    case alarmView
    case resetInfoView
    case settingView
    case myInformationView
    case onboardingExtraView
    case onboardingExtraCompleteView
    case tapView
    case webView(title: String, url: URL)
}
