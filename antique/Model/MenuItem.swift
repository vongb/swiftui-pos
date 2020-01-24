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
    
    enum CodingKeys : String, CodingKey {
        case name
        case price
        case hasSugarLevels
        case hasIceLevels
        case iceLevelIndex
        case canUpsize
        case upsizePrice
    }
}
