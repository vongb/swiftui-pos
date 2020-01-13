import SwiftUI

struct MenuSection: Codable, Identifiable {
    let id : UUID = UUID()
    var name: String
    var items: [MenuItem]
    
    enum CodingKeys : String, CodingKey {
        case name
        case items
    }
}

class Menu : ObservableObject {
    @Published var items : [MenuSection] = Bundle.main.decode([MenuSection].self, from: "menu.json")
}

