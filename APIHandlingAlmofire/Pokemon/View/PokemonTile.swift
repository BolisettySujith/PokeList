
import SwiftUI

struct PokemonTile: View {
    let pokemon: PokemonWithImage

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: pokemon.imageURL)) { phase in
                switch phase {
                case .empty:
                    // Show placeholder when image is loading
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                case .success(let image):
                    // Show the image when it loads successfully
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                case .failure(let error):
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                @unknown default:
                    // Handle unknown states
                    EmptyView()
                }
            }

            Text(pokemon.name.capitalized)
                .font(.headline)
        }
    }
}

#Preview {
    PokemonTile(pokemon: PokemonWithImage(name: "charmander", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/4.png"))
}
