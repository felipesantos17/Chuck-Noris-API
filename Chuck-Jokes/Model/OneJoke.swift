import Foundation

struct OneJoke: Codable {
    let id: String
    let categories: [String]
    let iconUrl: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case categories
        case iconUrl = "icon_url"
        case value
    }
    
}
