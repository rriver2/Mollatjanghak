//
//  TextFieldDynamicWidth.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

struct TextFieldDynamicWidth: View {
    let title: String
    @Binding var text: String
    @FocusState private var isKeyBoardOn: Bool
    
    @State private var textRect = CGRect()
    
    var body: some View {
        ZStack {
            Text(text == "" ? title : text).background(GlobalGeometryGetter(rect: $textRect)).layoutPriority(1).opacity(0)
            HStack {
                TextField(text: $text) {
                    Text(title)
                        .foregroundStyle(.gray300)
                }
                .focused($isKeyBoardOn)
                .frame(width: textRect.width)
            }
        }
        .onChange(of: text) { oldValue, newValue in
            let filtered = newValue.filter { "0123456789".contains($0) }
            if filtered != newValue {
                self.text = filtered
            }
            formatNumber()
        }
    }
    
    private func formatNumber() {
        if let number = Int(text) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            if let formatted = formatter.string(from: NSNumber(value: number)) {
                text = formatted
            }
        }
    }
}

struct GlobalGeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }
        
        return Rectangle().fill(Color.clear)
    }
}
