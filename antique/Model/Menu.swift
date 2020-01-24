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
    @Published var sugarLevels = ["None", "Less", "Regular", "Extra"]
    
    @Published var iceLevels : [[String]] = [["Hot"],
                                        ["Hot", "Less", "Regular"],
                                        ["None", "Less", "Regular"]]
    
    func refreshMenuItems() {
        self.items = Bundle.main.decode([MenuSection].self, from: "menu.json")
    }
}

