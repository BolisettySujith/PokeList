//
//  PokemonListPresenter.swift
//  APIHandlingAlmofire
//
//  Created by Havells on 06/02/25.
//

import Foundation

protocol PokemonListPresenterProtocol {
    var pokemons: [PokemonWithImage] { get set }
    var isLoading: Bool { get set }
    var isFetchingMore: Bool { get set }

    func fetchPokemons(initialLoad: Bool)
    func fetchMorePokemons()
}


class PokemonListPresenter: ObservableObject, PokemonListPresenterProtocol {
    @Published var pokemons: [PokemonWithImage] = []
    @Published var isLoading: Bool = false
    @Published var isFetchingMore: Bool = false
    
    private let interactor: PokemonListInteractorProtocol

    init(interactor: PokemonListInteractorProtocol) {
        self.interactor = interactor
    }

    func fetchPokemons(initialLoad: Bool) {
        if isLoading || isFetchingMore { return }
        if initialLoad {
            self.isLoading = true
        } else {
            self.isFetchingMore = true
        }
        
        interactor.fetchPokemons(initialLoad: initialLoad) { result in
            DispatchQueue.main.async {
                self.isFetchingMore = false
                self.isLoading = false
                
                switch result {
                case .success(let newPokemons):
                    self.pokemons.append(contentsOf: newPokemons)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchMorePokemons() {
        fetchPokemons(initialLoad: false)
    }
}
