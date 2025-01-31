//
//  APIHandlingAlmofireApp.swift
//  APIHandlingAlmofire
//
//  Created by Havells on 21/01/25.
//

import SwiftUI

@main
struct APIHandlingAlmofireApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListRouter.createModule()
        }
    }
}
