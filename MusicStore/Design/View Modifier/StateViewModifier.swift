//
//  StateViewModifier.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct StateViewModifier: ViewModifier {
    var isLoading: Bool = false

    var error: Error?

    var isEmpty: Bool = false
    var recoveryAction: (() -> Void)?

    func body(content: Content) -> some View {
        if isLoading {
            ProgressView()
        } else if error != nil {
            ContentUnavailableView(label: {
                Text("Request Failed")
            }, description: {
                Text(error?.localizedDescription ?? "")
            }, actions: {
                if let recoveryAction {
                    Button("Try Again", action: {
                        recoveryAction()
                    })
                }
            })
        } else if isEmpty {
            ContentUnavailableView(
                "Empty",
                systemImage: "archivebox",
                description: Text("Currently no results, try to search another keywords.")
            )
        } else {
            content
        }
    }
}

public extension View {
    func stateAware(
        isLoading: Bool = false,
        error: Error? = nil,
        isEmpty: Bool = false,
        recoveryAction: (() -> Void)? = nil
    ) -> some View {
        modifier(StateViewModifier(
            isLoading: isLoading,
            error: error,
            isEmpty: isEmpty,
            recoveryAction: recoveryAction
        ))
    }
}
