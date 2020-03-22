import SwiftUI

struct MenuSection: Codable, Identifiable {
    let id : UUID = UUID()
    var name: String
    var items: [MenuItem]
    
    enum CodingKeys : String, CodingKey {
        case name
        case items
    }
    
    func contains(_ id: String) -> Int {
        for(index, menuItem) in self.items.enumerated() {
            if id == menuItem.id.uuidString {
                return index
            }
        }
        return -1;
    }
    
    mutating func add(_ item: MenuItem) {
        self.items.append(item)
    }
    
    mutating func update(id: String, item: MenuItem) {
        let index = contains(id)
        if index != -1  {
            self.items[index].update(item)
        }
    }
    
    mutating func remove(_ id: String) {
        let index = self.contains(id)
        if index != -1 {
            self.items.remove(at: index)
        }
    }
}

class Menu : ObservableObject {
    @Published var items : [MenuSection] = Bundle.main.readMenu()
    @Published var sugarLevels = ["None", "Less", "Regular", "Extra"]
    @Published var iceLevels : [[String]] = [["Hot"],
                                        ["Hot", "Less", "Regular"],
                                        ["None", "Less", "Regular"]]
    
    func refreshMenuItems() {
        self.items = Bundle.main.readMenu()
    }
    
    func resetMenu() {
        let items : [MenuSection] = Bundle.main.decode([MenuSection].self, from: "menu.json")
        Bundle.main.updateMenu(menuSections: items)
        refreshMenuItems()
    }
    
    func addItem(section: Int, item: MenuItem) {
        for (index, _) in self.items.enumerated() {
            if index == section {
                self.items[index].add(item)
                break
            }
        }
        Bundle.main.updateMenu(menuSections: self.items)
        refreshMenuItems()
    }
    
    func remove(_ id: String) {
        for(index, _) in self.items.enumerated() {
            self.items[index].remove(id)
        }
        Bundle.main.updateMenu(menuSections: self.items)
        refreshMenuItems()
    }
    
    func update(id: String, section newSection: Int, item: MenuItem) {
        for(menuSection, _) in self.items.enumerated() { // iterate over menu sections
            let indexInMenuSection = self.items[menuSection].contains(id) // checks if item exists in each section
            if indexInMenuSection != -1 { // if item exists
                if menuSection != newSection { // if current menu section is not the edited item section, move it
                    remove(id)
                    addItem(section: newSection, item: item)
                } else {
                    self.items[menuSection].items[indexInMenuSection].update(item)
                    Bundle.main.updateMenu(menuSections: self.items)
                    refreshMenuItems()
                }
            }
        }
    }
}

