//
//  SlotMachineView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct SlotMachineView: View {
    
    @State private var finalNumberList: [Int]
    @State private var rolledMachineCount: Int = 0
    @State private var timer: Timer?
    
    @State private var isFinished: Bool = false
    
    /// 슬롯머신을 자동으로 돌릴 횟수
    private let lastRolledMachineCount = 4
    
    init(finalNumberList: [Int]) {
        self.finalNumberList = finalNumberList
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(finalNumberList.indices, id: \.self) { index in
                    ScrollView {
                        ScrollViewReader { proxy in
                            ForEach(0..<10) { index in
                                Text(index.description)
                                    .frame(width: 31, height: 31)
                                    .background(isFinished ? .subGreen : .gray700)
                                    .foregroundStyle(.white)
                                    .cornerRadius(4)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 4)
                                    .id(index)
                            }
                            .onChange(of: rolledMachineCount, { _, newValue in
                                withAnimation(.spring()) {
                                    if isFinished {
                                        timer?.invalidate()
                                        proxy.scrollTo(finalNumberList[index], anchor: .center)
                                    } else {
                                        proxy.scrollTo(Int.random(in: 1..<10), anchor: .center)
                                    }
                                }
                            })
                        }
                    }
                    .frame(height: 40)
                }
            }
            .padding(.bottom, 100)
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
                    rolledMachineCount += 1
                    if rolledMachineCount == lastRolledMachineCount {
                        isFinished = true
                    }
                }
            }
        }
    }
}

#Preview {
    SlotMachineView(finalNumberList: [3,4,5])
}
