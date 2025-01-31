import Alamofire
import SwiftUI

struct ContentView: View {
    
    @StateObject var pokemonAPI = PokemonAPI()
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if pokemonAPI.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2) // Make the spinner bigger for the main load
                        .padding()
                } else {

                    List {
                        ForEach(filteredPokemons) { pokemon in
                            if let pokemonDetails = pokemon.pokemonDetails {
                                NavigationLink(destination: PokemonDetailsView(pokemon: pokemonDetails)) {
                                    PokemonTile(pokemon: pokemon)
                                }
                                .onAppear {
                                    if pokemon == filteredPokemons.last {
                                        pokemonAPI.fetchPokemonsData(initialLoad: false)
                                    }
                                }
                            } else {
                                PokemonTile(pokemon: pokemon)
                                .onAppear {
                                    if pokemon == filteredPokemons.last {
                                        pokemonAPI.fetchPokemonsData(initialLoad: false)
                                    }
                                }
                            }

                        }
                        
                        // Show bottom loader when fetching more data
                        if pokemonAPI.isFetchingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.75) // Make the bottom spinner smaller
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search Pokemons..")
                }
            }
            .onAppear {
                pokemonAPI.fetchPokemonsData(initialLoad: true)
            }
            .navigationTitle("Pokemons")
        }
    }
    
    private var filteredPokemons: [PokemonWithImage] {
        if searchText.isEmpty {
            return pokemonAPI.pokemons
        } else {
            return pokemonAPI.pokemons.filter { pokemon in
                pokemon.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    ContentView()
}
