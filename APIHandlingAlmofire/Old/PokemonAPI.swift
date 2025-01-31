
import Foundation
import Alamofire



class PokemonAPI : ObservableObject {
    
    @Published var pokemons : [PokemonWithImage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isFetchingMore: Bool = false
    
    private var currentPage: String?
    
    
    func fetchPokemonsData(initialLoad: Bool = true) {

        if isLoading || isFetchingMore { return }

        if initialLoad {
            self.isLoading = true
            self.errorMessage = nil
        } else {
            self.isFetchingMore = true
        }
        

        let urlString = initialLoad ? "https://pokeapi.co/api/v2/pokemon?limit=20" : currentPage ?? ""
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: Pokemons.self) { response in
                self.isLoading = false

            
                switch response.result {
                case .success(let pokemonsData):
                    if initialLoad {
                        self.pokemons = []
                    }
                    
                
                    let previousCount = self.pokemons.count
                    self.pokemons.append(contentsOf: pokemonsData.results.map {
                        PokemonWithImage(name: $0.name, imageURL: "", pokemonDetails: nil)
                    })

                    let group = DispatchGroup()
                    
                    // Fetch the details (including images) for each new Pokémon
                    for (index, pokemon) in pokemonsData.results.enumerated() {
                        
                        group.enter()
                        
                        let globalIndex = previousCount + index

                        self.fetchPokemonDetails(pokemon: pokemon, at: globalIndex) {
                            group.leave()
                        }
                    }
                    
                    // Check if there is a next page (pagination)
                    print(pokemonsData.next)
                    self.currentPage = pokemonsData.next
                    
                    // Wait for all requests to finish
                    group.notify(queue: .main) {
                        self.isFetchingMore = false
                    }

                case .failure(let error) :
                    self.errorMessage = "Failed to load Pokémon list: \(error.localizedDescription)"
                    self.isLoading = false
                    self.isFetchingMore = false
                }
        }
    }
    
    func fetchPokemonDetails(pokemon: Pokemon, at index: Int, completion: @escaping () -> Void) {
        AF.request(pokemon.url)
            .validate()
            .responseDecodable(of: PokemonDetails.self) { response in
                switch response.result {
                case .success(let pokemonDetails):
                    self.pokemons[index].imageURL = pokemonDetails.sprites.other.home.frontDefault
                    self.pokemons[index].pokemonDetails = pokemonDetails
                case .failure(let error):
                    print("Failed to load details for \(pokemon.name): \(error.localizedDescription)")
                }
                
                completion()
                
            }
    }
    
}
