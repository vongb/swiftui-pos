import SwiftUI

struct MenuSection: Codable, Identifiable {
    var id : UUID = UUID()
    var name: String
    var items: [MenuItem]
    
    enum CodingKeys : String, CodingKey {
        case name
        case items
    }
}
