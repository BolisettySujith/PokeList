
import Foundation

struct PokemonWithImage: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var imageURL: String
    var pokemonDetails: PokemonDetails?
}

struct Pokemons: Codable {
    let next: String
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    let id = UUID()
    let name: String
    let url: String
}



struct PokemonDetails: Codable, Equatable {
    static func == (lhs: PokemonDetails, rhs: PokemonDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let id: Int
    let name: String
    let types: [TypeInfo]
    let abilities: [AbilityInfo]
    let stats: [Stat]
    let height: Int
    let weight: Int
    let sprites: Sprites
    let moves: [Move]
    let species: Species
    let evolutionChain: EvolutionChain?

    // MARK: - Type Info
    struct TypeInfo: Codable {
        let type: TypeModel
    }

    struct TypeModel: Codable {
        let name: String
    }

    // MARK: - Ability Info
    struct AbilityInfo: Codable {
        let ability: Ability
    }

    struct Ability: Codable {
        let name: String
    }

    // MARK: - Stat Info
    struct Stat: Codable {
        let baseStat: Int
        let stat: StatType

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
    }

    struct StatType: Codable {
        let name: String
    }

    // MARK: - Sprites (Images)
    struct Sprites: Codable {
        let frontDefault: String
        let backDefault: String
        let frontShiny: String
        let backShiny: String
        let other: Other

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
            case backDefault = "back_default"
            case frontShiny = "front_shiny"
            case backShiny = "back_shiny"
            case other
        }
    }

    // MARK: - Other (Additional Sprites)
    struct Other: Codable {
        let home: Home
        let showdown: showdown

        struct Home: Codable {
            let frontDefault: String

            enum CodingKeys: String, CodingKey {
                case frontDefault = "front_default"
            }
        }
        
        struct showdown: Codable {
            let frontDefault: String
            let backDefault: String
            let frontShiny: String
            let backShiny: String
            
            enum CodingKeys: String, CodingKey {
                case frontDefault = "front_default"
                case backDefault = "back_default"
                case frontShiny = "front_shiny"
                case backShiny = "back_shiny"
            }
        }
    }
    


    // MARK: - Moves Info
    struct Move: Codable {
        let move: MoveName
    }

    struct MoveName: Codable {
        let name: String
    }

    // MARK: - Species Info
    struct Species: Codable {
        let name: String
        let url: String
    }

    // MARK: - Evolution Chain Info
    struct EvolutionChain: Codable {
        let url: String
    }
}
