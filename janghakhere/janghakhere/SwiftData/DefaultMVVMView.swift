//
//  DefaultMVVMView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//
#if DEBUG
import SwiftUI

actor DefaultMyManagerActor {
    func getData() async throws -> String {
        "some data!"
    }
}

@MainActor
final class DefaultMVVMViewModel: ObservableObject {
    let managerActor: DefaultMyManagerActor = DefaultMyManagerActor()
    
    @Published private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        let task = Task {
            do {
                myData = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

struct DefaultMVVMView: View {
    @StateObject private var viewModel = DefaultMVVMViewModel()
    
    var body: some View {
        Button("Click me") {
            viewModel.onCallToActionButtonPressed()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

#Preview {
    DefaultMVVMView()
}
#endif
