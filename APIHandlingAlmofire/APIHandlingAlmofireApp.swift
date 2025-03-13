import SwiftUI

@main
struct APIHandlingAlmofireApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListRouter.createModule()
        }
    }
}

