//
//  PokemonListInteractor.swift
//  APIHandlingAlmofire
//
//  Created by Havells on 06/02/25.
//

import Foundation
import Alamofire

protocol PokemonListInteractorProtocol: AnyObject {
    func fetchPokemons(initialLoad: Bool, completion: @escaping (Result<[PokemonWithImage], Error>) -> Void)
}

class PokemonListInteractor: PokemonListInteractorProtocol {
    private var currentPage: String?

    func fetchPokemons(initialLoad: Bool, completion: @escaping (Result<[PokemonWithImage], Error>) -> Void) {
        let urlString = initialLoad ? "https://pokeapi.co/api/v2/pokemon?limit=20" : (currentPage ?? "")
        print(initialLoad)
        print(urlString)
        AF.request(urlString)
            .validate()
            .responseDecodable(of: Pokemons.self) { response in
                switch response.result {
                case .success(let pokemonsData):
                    self.currentPage = pokemonsData.next
                    let group = DispatchGroup()
                    var fetchedPokemons: [PokemonWithImage] = []

                    for pokemon in pokemonsData.results {
                        group.enter()
                        self.fetchPokemonDetails(for: pokemon) { result in
                            switch result {
                            case .success(let detailedPokemon):
                                fetchedPokemons.append(detailedPokemon)
                            case .failure(let error):
                                print("Error fetching details: \(error.localizedDescription)")
                            }
                            group.leave()
                        }
                    }

                    group.notify(queue: .main) {
                        completion(.success(fetchedPokemons))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    private func fetchPokemonDetails(for pokemon: Pokemon, completion: @escaping (Result<PokemonWithImage, Error>) -> Void) {
        AF.request(pokemon.url)
            .validate()
            .responseDecodable(of: PokemonDetails.self) { response in
                switch response.result {
                case .success(let details):
                    let pokemonWithImage = PokemonWithImage(name: pokemon.name, imageURL: details.sprites.other.home.frontDefault, pokemonDetails: details)
                    completion(.success(pokemonWithImage))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
