import SwiftUI

@main
struct ARGameApp: App {
    var body: some Scene {
        WindowGroup {
            TitleView()
                .edgesIgnoringSafeArea(.bottom)
                .environmentObject(SoundManager.shared)
                .environmentObject(LocalizableManager.shared)
        }
    }
}
