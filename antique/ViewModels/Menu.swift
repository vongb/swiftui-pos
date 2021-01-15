







import SwiftUI


class Menu : ObservableObject {
    @Published var items : [MenuSection] = Bundle.main.readMenu()

    let sugarLevels = ["0%", "25%", "50%", "75%", "100%"]
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
    
    func addItem(section: Int, item: MenuItem) -> Bool{
        for (index, _) in self.items.enumerated() {
            if index == section {
                self.items[index].add(item)
                update()
                refreshMenuItems()
                return true
            }
        }
        return false
    }
    
    func remove(_ id: String) {
        for(index, _) in self.items.enumerated() {
            self.items[index].remove(id)
        }
        update()
        refreshMenuItems()
    }
    
    func deleteMenuItem(_ offsets: IndexSet, _ section: Int) {
        items[section].items.remove(atOffsets: offsets)
        update()
    }
    
    func updateItem(id: String, section: Int, item: MenuItem) {
        print("ID Received for update: \(id)")
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
    
    func moveSection(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
        update()
        refreshMenuItems()
    }

    
    func appendNewSection(_ name: String) -> Bool {
        if !containsSection(name) {
            self.items.append(MenuSection(name: name, items: []))
            update()
            refreshMenuItems()
            return true
        } else {
            return false
        }
    }
    
    func updateSectionName(newName : String, for section: MenuSection) -> Bool {
        if !containsSection(newName) {
            let index = getSectionIndex(name: section.name)
            self.items[index].name = newName
            update()
            refreshMenuItems()
            return true
        } else {
            return false
        }
    }
    
    func containsSection(_ name: String) -> Bool {
        for section in items {
            if section.name == name {
                return true
            }
        }
        return false
    }
    
    func deleteSection(_ sectionIDToDelete : String) {
        var indexToRemove : Int?
        for (index, section) in items.enumerated() {
            if section.id.uuidString == sectionIDToDelete {
                indexToRemove = index
                break
            }
        }
        if let safeIndex = indexToRemove {
            items.remove(at: safeIndex)
        }
        update()
        refreshMenuItems()
    }
    
    func deleteSection(_ offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        update()
    }
    
    static func getMenuSections() -> [String] {
        let menuSections = Bundle.main.readMenu()
        var sections = [String]()
        menuSections.forEach { (section) in
            sections.append(section.name)
        }
        return sections
    }
    
    static func getMenuDictionary() -> [String : Set<String>] {
        let sections = Bundle.main.readMenu()
        var dictionary = [String : Set<String>]()
        for menuSection in sections {
            var tempSet = Set<String>()
            menuSection.items.forEach { (item) in
                tempSet.insert(item.name)
            }
            dictionary.updateValue(tempSet, forKey: menuSection.name)
        }
        return dictionary
    }
}

