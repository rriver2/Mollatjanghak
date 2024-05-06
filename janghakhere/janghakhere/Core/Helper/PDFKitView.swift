//
//  PDFView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/6/24.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
    }
}

struct PDFViewerView: View {
    @Environment(\.dismiss) private var dismiss
    let url: URL
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("닫기") {
                    dismiss()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            PDFKitView(url: url)
        }
        .ignoresSafeArea()
    }
}
