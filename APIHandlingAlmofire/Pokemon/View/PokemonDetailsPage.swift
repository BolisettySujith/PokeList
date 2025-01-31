import SwiftUI
import SDWebImage
import SDWebImageSwiftUI


struct PokemonDetailsView: View {
    let pokemon: PokemonDetails

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Pokémon Image
                AsyncImage(url: URL(string: pokemon.sprites.other.home.frontDefault)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 280)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                
                Spacer()
                    .frame(height: 0)
                
                Text("Preview")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                HStack {
                    ForEach([pokemon.sprites.frontDefault,
                             pokemon.sprites.backDefault,
                             pokemon.sprites.frontShiny,
                             pokemon.sprites.backShiny], id: \.self) { imageURL in
                        renderBottomImages(imageurl: imageURL, height: 60, width: 70)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    ForEach([pokemon.sprites.other.showdown.frontDefault,
                             pokemon.sprites.other.showdown.backDefault,
                             pokemon.sprites.other.showdown.frontShiny,
                             pokemon.sprites.other.showdown.backShiny
                            ], id: \.self) { imageURL in
                        renderGifBottomImages(imageurl: imageURL, height: 70, width: 70)
                    }
                }
                .padding(.horizontal)

                // Height and Weight
                VStack(alignment: .leading, spacing: 10) {
                    Text("Physical Attributes")
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        Text("Height:")
                        Spacer()
                        Text("\(pokemon.height)")
                    }
                    
                    HStack {
                        Text("Weight:")
                        Spacer()
                        Text("\(pokemon.weight)")
                    }
                }
                .padding(.horizontal)

                // Stats
                VStack(alignment: .leading, spacing: 10) {
                    Text("Stats")
                        .font(.title2)
                        .bold()
                    
                    ForEach(pokemon.stats, id: \.stat.name) { stat in
                        HStack {
                            Text(stat.stat.name.capitalized)
                            Spacer()
                            Text("\(stat.baseStat)")
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)


                
                // Type Information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Type")
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        ForEach(pokemon.types, id: \.type.name) { typeInfo in
                            Text(typeInfo.type.name.capitalized)
                                .padding(8)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)

                // Abilities
                VStack(alignment: .leading, spacing: 10) {
                    Text("Abilities")
                        .font(.title2)
                        .bold()
                    HStack {
                        ForEach(pokemon.abilities, id: \.ability.name) { abilityInfo in
                            Text(abilityInfo.ability.name.capitalized)
                                .padding(8)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)


                // Moves
                VStack(alignment: .leading, spacing: 10) {
                    Text("Moves")
                        .font(.title2)
                        .bold()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(pokemon.moves, id: \.move.name) { moveInfo in
                                Text(moveInfo.move.name.capitalized)
                                    .padding(8)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("\(pokemon.name.capitalized) (#\(pokemon.id))")
    }
    
    func renderBottomImages(imageurl: String, height: Double, width: Double) -> some View {
        AsyncImage(url: URL(string: imageurl)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: width, height: height) // Adjust size as needed
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8)) // Rounded corners for better visuals
        
    }
    
    func renderGifBottomImages(imageurl: String, height: Double, width: Double) -> some View {
        WebImage(url: URL(string: imageurl)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: width, height: height) // Adjust size as needed
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8)) // Rounded corners for better visuals
        
    }

}

struct PokemonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePokemon = PokemonDetails(
            id: 1,
            name: "bulbasaur",
            types: [PokemonDetails.TypeInfo(type: PokemonDetails.TypeModel(name: "grass"))],
            abilities: [PokemonDetails.AbilityInfo(ability: PokemonDetails.Ability(name: "overgrow"))],
            stats: [
                PokemonDetails.Stat(baseStat: 45, stat: PokemonDetails.StatType(name: "hp")),
                PokemonDetails.Stat(baseStat: 49, stat: PokemonDetails.StatType(name: "attack"))
            ],
            height: 7,
            weight: 69,
            sprites: PokemonDetails.Sprites(
                frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                other: PokemonDetails.Other(
                    home: PokemonDetails.Other.Home(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png"),
                    showdown: PokemonDetails.Other.showdown(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/4.gif",
                        backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/4.gif",
                        frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/4.gif",
                        backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/back/4.gif"
                    )
                )
            ),
            moves: [PokemonDetails.Move(move: PokemonDetails.MoveName(name: "tackle"))],
            species: PokemonDetails.Species(name: "bulbasaur", url: ""),
            evolutionChain: nil
        )
        
        PokemonDetailsView(pokemon: samplePokemon)
    }
}
