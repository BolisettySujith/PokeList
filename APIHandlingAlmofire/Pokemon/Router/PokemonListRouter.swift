//
//  PokemonListRouter.swift
//  APIHandlingAlmofire
//
//  Created by Havells on 06/02/25.
//

import Foundation
import SwiftUI


struct PokemonListRouter {
    static func createModule() -> some View {
        let interactor = PokemonListInteractor()
        let presenter = PokemonListPresenter(interactor: interactor)
        return PokemonListView(presenter: presenter)
    }
}
