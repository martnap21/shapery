import SwiftUI

@main
@MainActor
struct ShaperyApp: App {
    var body: some Scene {
        WindowGroup {
            FactoryView()
                .preferredColorScheme(.dark)
        }
    }
}
