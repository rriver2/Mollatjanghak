//
//  ScholarshipBoxManager.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/21/24.
//

import SwiftUI

//FIXME: 제거하기
struct ScholarshipBoxManager {
    ///버튼 클릭 시 저장 저장완료 지원예정 지원완료 변경하기
    static func scholarshipStatusButtonPressed(status: publicAnnouncementStatus) -> PublicAnnouncementStatusCategory {
        let key = UserDefaultKey.publicAnnouncementStatusList
        // userdefault에서 값 불러오기
        var list = UserDefaults.getObjectFromDevice(key: key, [publicAnnouncementStatus].self) ?? []
        
        // 변경하고
        if let index = list.firstIndex(where: { $0.id == status.id }){
            list[index].status = status.status
            let _ = list.remove(at: index)
        }
        list.append(publicAnnouncementStatus(id: status.id, status: status.status))
        
        // 저장하기
        UserDefaults.saveObjectInDevice(key: key, content: list)
        
        // 반환하기
        return status.status
    }
    
    /// viewmodel list 불러올 때 저장 저장완료 지원예정 지원완료 확인해서 변경해주기
    static func checkScholarshipBoxListStatus(scholarshipBoxList: [ScholarshipBox]) -> [ScholarshipBox] {
        var newScholarshipBoxList: [ScholarshipBox] = []
        let key = UserDefaultKey.publicAnnouncementStatusList
        // userdefault에서 값 불러오기
        let list = UserDefaults.getObjectFromDevice(key: key, [publicAnnouncementStatus].self) ?? []
        
        // 전체 변경하고
        for scholarshipBox in scholarshipBoxList {
            if let index = list.firstIndex(where: { $0.id == scholarshipBox.id }){
                var newScholarshipBox = scholarshipBox
                newScholarshipBox.publicAnnouncementStatus = list[index].status
                newScholarshipBoxList.append(newScholarshipBox)
            } else {
                newScholarshipBoxList.append(scholarshipBox)
            }
        }
        
        return newScholarshipBoxList
    }
}
