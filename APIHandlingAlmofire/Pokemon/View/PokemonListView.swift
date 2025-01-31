//
//  PokemonListView.swift
//  APIHandlingAlmofire
//
//  Created by Havells on 06/02/25.
//

import Foundation
import SwiftUI

struct PokemonListView: View {
    @ObservedObject var presenter: PokemonListPresenter
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if presenter.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                } else {
                    List {
                        ForEach(filteredPokemons) { pokemon in
                            if let details = pokemon.pokemonDetails {
                                NavigationLink(destination: PokemonDetailsView(pokemon: details)) {
                                    PokemonTile(pokemon: pokemon)
                                }
                                .onAppear {
                                    if pokemon == filteredPokemons.last {
                                        presenter.fetchMorePokemons()
                                    }
                                }
                            } else {
                                PokemonTile(pokemon: pokemon)
                                .onAppear {
                                    if pokemon == filteredPokemons.last {
                                        presenter.fetchMorePokemons()
                                    }
                                }
                            }
                        }

                        if presenter.isFetchingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.75)
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search Pokemons...")
                }
            }
            .onAppear {
                presenter.fetchPokemons(initialLoad: true)
            }
            .navigationTitle("Pokemons")
        }
    }
    
    private var filteredPokemons: [PokemonWithImage] {
        if searchText.isEmpty {
            return presenter.pokemons
        } else {
            return presenter.pokemons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
