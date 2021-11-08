import Foundation

// defini como eu quero que seja estruturado esses dados
struct OneJoke: Decodable {
    let categories: [String]?
    let icon_url: String?
    let value: String
}
