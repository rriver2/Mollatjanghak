//
//  EnrollmentStatusGrid.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/27/24.
//

import SwiftUI

enum EnrollmentStatus: String, CaseIterable, CustomStringConvertible, Codable {
    case incomming = "입학예정"
    case enrolled = "재학"
    case deferred = "유예"
    case leaveOfAbsence = "휴학"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

struct EnrollmentStatusGrid<T: Hashable & CustomStringConvertible>: View {
    
    let titleList: [T]
    @Binding var selectedElement: T
    @Binding var degreesStatus: DegreesStatus
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .leading), count: 3),
            spacing: 16
        ) {
            ForEach(
                titleList.filter { title in
                    if degreesStatus == .bachelor {
                        return title.description != "선택 안 됨"
                    } else {
                        return title.description != "선택 안 됨" && title.description != "유예"
                    }
                },
                id : \.self){ title in
                Button {
                    selectedElement = title
                } label: {
                    Text(title.description)
                        .font(.title_xsm)
                        .padding(.vertical, 13)
                        .foregroundStyle(
                            selectedElement == title
                            ? .white
                            : .gray600
                        )
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedElement == title
                            ? .mainGray
                            : .gray70
                        )
                        .cornerRadius(4)
                }
            }
        }
        .onChange(of: degreesStatus) { _, newValue in
            if newValue != .bachelor && selectedElement as! EnrollmentStatus == EnrollmentStatus.deferred {
                selectedElement = EnrollmentStatus.notSelected as! T
            }
        }
    }
}
