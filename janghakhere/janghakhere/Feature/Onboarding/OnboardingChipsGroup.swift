//
//  OnboardingChipsGroup.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/4/24.
//

import SwiftUI

struct OnboardingChipsGroup: View {
    @ObservedObject var viewModel: OnboardingExtraViewModel
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach($viewModel.chips, id: \.id) { chip in
                    OnboardingChip(viewModel: viewModel, chip: chip)
                        .padding(.trailing, 12)
                        .padding(.bottom, 12)
                        .alignmentGuide(.leading) { dimension in
                            if abs(width - dimension.width) > geometry.size.width {
                                width = 0
                                height -= dimension.height
                            }
                            let result = width
                            if chip.id == $viewModel.chips.last!.id {
                                width = 0
                            } else {
                                width -= dimension.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { dimension in
                            let result = height
                            if chip.id == viewModel.chips.last!.id {
                                height = 0
                            }
                            return result
                        }
                }
            }
        }
    }
}

private struct OnboardingChip: View {
    let viewModel: OnboardingExtraViewModel
    let chip: Binding<OnboardingChipModel>
    
    var body: some View {
        Text(chip.title.wrappedValue)
            .font(.text_md)
            .foregroundStyle(
                chip.isSelected.wrappedValue
                ? .white
                : .gray500)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .circular)
                    .stroke(
                        chip.isSelected.wrappedValue
                        ? .clear
                        : .gray300, lineWidth: 1)
                    .fill(
                        chip.isSelected.wrappedValue
                        ? .mainGray
                        : .white)
            )
            .onTapGesture {
                chip.isSelected.wrappedValue.toggle()
                viewModel.updateChipSelection()
            }
    }
}
