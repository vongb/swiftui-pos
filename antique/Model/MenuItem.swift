import SwiftUI

struct MenuItem: Codable, Equatable, Identifiable {
    let id : UUID = UUID()
    
    var name: String

    var price: Double

    var hasSugarLevels: Bool = true
    
    var iceLevelIndex: Int = 1
    var hasIceLevels: Bool = true
    
    var canUpsize : Bool = true
    var upsizePrice : Double = 0.0
    
    var specialDiscount : Double? = 0.5
    
    init() {
        self.name = "No Item Name"
        self.price = 0.5
        self.hasSugarLevels = true
        self.iceLevelIndex = 0
        self.hasIceLevels = true
        self.upsizePrice = 0.5
        self.canUpsize = true
        self.specialDiscount = 0.5
    }
    
//    init(name: String, price: Double) {
//        self.name = name
//        self.price = price
//        self.hasSugarLevels = true
//        self.iceLevelIndex = 0
//        self.hasIceLevels = true
//        self.upsizePrice = 0.5
//        self.canUpsize = true
//        self.specialDiscount = 0.5
//    }
    
    init(name: String = "No Name", price: Double = 0.5, hasSugarLevels: Bool = true, iceLevelIndex: Int = 0, hasIceLevels : Bool = true, canUpsize: Bool = true, upsizePrice : Double = 0.5, specialDiscount: Double = 0.5) {
        self.name = name
        self.price = price
        self.hasSugarLevels = hasSugarLevels
        self.iceLevelIndex = iceLevelIndex
        self.hasIceLevels = hasIceLevels
        self.upsizePrice = upsizePrice
        self.canUpsize = canUpsize
        self.specialDiscount = specialDiscount
    }
    
    init(from decoder: Decoder) throws {
        let newJSON = try decoder.container(keyedBy: Keys.self)
        if let tempName = try? newJSON.decodeIfPresent(String.self, forKey: .name) {
            name = tempName
        } else {
            name = "No Name"
        }
        if let tempPrice = try? newJSON.decodeIfPresent(Double.self, forKey: .price) {
            price = tempPrice
        } else {
            price = 2.5
        }
        if let temp = try? newJSON.decodeIfPresent(Bool.self, forKey: .hasSugarLevels) {
            hasSugarLevels = temp
        } else {
            hasSugarLevels = true
        }
        if let temp = try? newJSON.decodeIfPresent(Bool.self, forKey: .hasIceLevels) {
            hasIceLevels = temp
        } else {
            hasIceLevels = true
        }
        if let temp = try? newJSON.decodeIfPresent(Int.self, forKey: .iceLevelIndex) {
            iceLevelIndex = temp
        } else {
            iceLevelIndex = 0
        }
        if let temp = try? newJSON.decodeIfPresent(Bool.self, forKey: .canUpsize) {
            canUpsize = temp
        } else {
            canUpsize = true
        }
        if let temp = try? newJSON.decodeIfPresent(Double.self, forKey: .upsizePrice) {
            upsizePrice = temp
        } else {
            upsizePrice = 0.5
        }
        if let savedSpecialDiscountPrice = try? newJSON.decodeIfPresent(Double.self, forKey: .specialDiscount) {
            specialDiscount = savedSpecialDiscountPrice
        } else {
            specialDiscount = 0.5
        }
    }
    
//    init(_ item: MenuItemDTO) {
//        self.name = item.name ?? "No Item Name"
//        self.price = item.price ?? 2.5
//        self.hasSugarLevels = item.hasSugarLevels ?? true
//        self.iceLevelIndex = item.iceLevelIndex ?? 0
//        self.hasIceLevels = item.hasIceLevels ?? true
//        self.canUpsize = item.canUpsize ?? true
//        self.upsizePrice = item.upsizePrice ?? 0.5
//        self.specialDiscount = item.specialDiscount ?? 0.5
//    }
    
    mutating func update(_ item: MenuItem) {
        self.name = item.name
        self.price = item.price
        
        self.hasSugarLevels = item.hasSugarLevels
        
        self.iceLevelIndex = item.iceLevelIndex
        self.hasIceLevels = item.hasIceLevels
        
        self.canUpsize = item.canUpsize
        self.upsizePrice = item.upsizePrice
        
        self.specialDiscount = item.specialDiscount
    }
    
    

    private enum Keys : String, CodingKey {
        case name
        case price
        case hasSugarLevels
        case iceLevelIndex
        case hasIceLevels
        case canUpsize
        case upsizePrice
        case specialDiscount
    }
}

//struct MenuItemDTO : Codable {
//    var name: String?
//    var price: Double?
//    var hasSugarLevels: Bool?
//
//    var iceLevelIndex: Int?
//    var hasIceLevels: Bool?
//
//    var canUpsize : Bool?
//    var upsizePrice : Double?
//
//    var specialDiscount : Double?
//
//    init() {
//        self.name = "No Item Name"
//        self.price = 2.5
//        self.hasSugarLevels = true
//        self.iceLevelIndex = 0
//        self.hasIceLevels = true
//        self.canUpsize = true
//        self.upsizePrice = 0.5
//        self.specialDiscount = 0.5
//    }
//
//    init(from decoder: Decoder) throws {
//        let newJSON = try decoder.container(keyedBy: Keys.self)
//        name = try? newJSON.decode(String.self, forKey: .name)
//        price = try? newJSON.decode(Double.self, forKey: .price)
//        hasSugarLevels = try? newJSON.decode(Bool.self, forKey: .hasSugarLevels)
//        hasIceLevels = try? newJSON.decode(Bool.self, forKey: .hasIceLevels)
//        iceLevelIndex = try? newJSON.decode(Int.self, forKey: .iceLevelIndex)
//        canUpsize = try? newJSON.decode(Bool.self, forKey: .canUpsize)
//        upsizePrice = try? newJSON.decode(Double.self, forKey: .upsizePrice)
//
//        if let savedSpecialDiscountPrice = try? newJSON.decodeIfPresent(Double.self, forKey: .specialDiscount) {
//            specialDiscount = savedSpecialDiscountPrice
//        } else {
//            specialDiscount = nil
//        }
//    }
//
//    private enum Keys : String, CodingKey {
//        case name
//        case price
//        case hasSugarLevels
//        case iceLevelIndex
//        case hasIceLevels
//        case canUpsize
//        case upsizePrice
//        case specialDiscount
//    }
//}
