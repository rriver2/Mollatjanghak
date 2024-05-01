//
//  PathType.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

enum PathType: Hashable {
    case detailScholarshipView(id: String)
    case searchScholarshipView
    case onboardingBeginView
    case onboardingMainView
    case onboardingWaitingView(name: String)
    case alarmView
    case settingWebView(title: String, url: URL)
    case resetInfoView
    case settingView
    case myInformationView
}
