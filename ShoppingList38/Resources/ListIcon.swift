//
//  ListIcon.swift
//  ShoppingList38
//
//  Created by el on 12.09.2026.
//

import Foundation

// Raw values are persisted identifiers and must stay stable when cases are renamed.
// swiftlint:disable redundant_string_enum_value
enum ListIcon: String, CaseIterable, Identifiable {
    
    case snowflake = "snowflake"
    case airplane = "airplane"
    case alert = "alert"
    case balloon = "balloon"
    case bandage = "bandage"
    case barbell = "barbell"
    case bed = "bed"
    case briefcase = "briefcase"
    case wrench = "wrench"
    case building = "building"
    case calendar = "calendar"
    case gift = "gift"
    case palette = "palette"
    case cart = "cart"
    case car = "car"
    case food = "food"
    case paw = "paw"
    case gameController = "gameController"

    var id: String {
        rawValue
    }

    var assetName: String {
        switch self {
        case .snowflake: "SnowflakeIcon"
        case .airplane: "AirplaneIcon"
        case .alert: "AlertIcon"
        case .balloon: "BalloonIcon"
        case .bandage: "BandageIcon"
        case .barbell: "BarbellIcon"
        case .bed: "BedIcon"
        case .briefcase: "BriefcaseIcon"
        case .wrench: "WrenchIcon"
        case .building: "BuildingIcon"
        case .calendar: "CalendarIcon"
        case .gift: "GiftIcon"
        case .palette: "PaletteIcon"
        case .cart: "CartIcon"
        case .car: "CarIcon"
        case .food: "FoodIcon"
        case .paw: "PawIcon"
        case .gameController: "GameControllerIcon"
        }
    }

    var accessibilityName: String {
        switch self {
        case .snowflake: "Снежинка"
        case .airplane: "Самолёт"
        case .alert: "Восклицательный знак"
        case .balloon: "Воздушный шар"
        case .bandage: "Пластырь"
        case .barbell: "Гантель"
        case .bed: "Кровать"
        case .briefcase: "Чемодан"
        case .wrench: "Гаечный ключ"
        case .building: "Здание"
        case .calendar: "Календарь"
        case .gift: "Подарок"
        case .palette: "Палитра"
        case .cart: "Тележка"
        case .car: "Автомобиль"
        case .food: "Еда"
        case .paw: "Лапа"
        case .gameController: "Игровой контроллер"
        }
    }
}
// swiftlint:enable redundant_string_enum_value
