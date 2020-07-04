import SwiftUI

class Menu : ObservableObject {
    @Published var items : [MenuSection] = Bundle.main.readMenu()

    let sugarLevels = ["None", "Less", "Regular", "Extra"]
    let iceLevels : [[String]] = [["Hot"],
                                        ["Hot", "Less", "Regular"],
                                        ["None", "Less", "Regular"]]

    
    func update() {
        Bundle.main.updateMenu(menuSections: items)
    }
    
    func refreshMenuItems() {
        self.items = Bundle.main.readMenu()
    }
    
    func resetMenu() {
        let items : [MenuSection] = Bundle.main.decode([MenuSection].self, from: "menu.json")
        Bundle.main.updateMenu(menuSections: items) // updating from project files
        refreshMenuItems()
    }
    
    func addItem(section: Int, item: MenuItem) {
        for (index, _) in self.items.enumerated() {
            if index == section {
                self.items[index].add(item)
                break
            }
        }
        update()
        refreshMenuItems()
    }
    
    func remove(_ id: String) {
        for(index, _) in self.items.enumerated() {
            self.items[index].remove(id)
        }
        update()
        refreshMenuItems()
    }
    
    func update(id: String, section: Int, item: MenuItem) {
        let indexInMenuSection = self.items[section].contains(id) // checks if item exists in each section
        if indexInMenuSection != -1 { // if item exists
            self.items[section]
                .items[indexInMenuSection]
                .update(item)
        }
        update()
        refreshMenuItems()
    }
    
    func getSectionIndex(name: String) -> Int {
        for (index, section) in items.enumerated() {
            if section.name == name {
                return index;
            }
        }
        return -1
    }
}

