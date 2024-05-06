//
//  SlotMachineView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct SlotMachineView: View {
    
    @State private var rolledMachineCount: Int = 0
    @State private var timer: Timer?
    
    @Binding var finalNumberList: [Int]
    @Binding var isFinished: Bool
    @Binding var isStopped: Bool
    
    /// 슬롯머신을 자동으로 돌릴 횟수
    @State private var lastRolledMachineCount = 4
    
    init(finalNumberList: Binding<[Int]>, isFinished: Binding<Bool>, isStopped: Binding<Bool>) {
        self._finalNumberList = finalNumberList
        self._isFinished = isFinished
        self._isStopped = isStopped
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
                                    .background(isStopped ? .gray800 : .gray600)
                                    .foregroundStyle(.white)
                                    .cornerRadius(4)
                                    .padding(.horizontal, 1)
                                    .padding(.vertical, 4)
                                    .id(index)
                            }
                            .onChange(of: rolledMachineCount, { _, newValue in
                                withAnimation(.spring()) {
                                    if isStopped {
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
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
                    rolledMachineCount += 1
                    if !isFinished {
                        lastRolledMachineCount += 2
                    } else if rolledMachineCount == lastRolledMachineCount {
                        isStopped = true
                        HapticManager.instance.notification(type: .error)
                    }
                }
            }
        }
    }
}
