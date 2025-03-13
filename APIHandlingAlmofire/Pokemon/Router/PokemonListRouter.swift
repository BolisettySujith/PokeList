import Foundation
import SwiftUI


struct PokemonListRouter {
    static func createModule() -> some View {
        let interactor = PokemonListInteractor()
        let presenter = PokemonListPresenter(interactor: interactor)
        return PokemonListView(presenter: presenter)
    }
}
