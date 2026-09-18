//
//  ListIcon.swift
//  ShoppingList38
//
//  Created by el on 12.09.2026.
//

import Foundation

enum ListIcon: String, CaseIterable, Identifiable {
    
    case snowflake = "SnowflakeIcon"
    case airplane = "AirplaneIcon"
    case alert = "AlertIcon"
    case balloon = "BalloonIcon"
    case bandage = "BandageIcon"
    case barbell = "BarbellIcon"
    case bed = "BedIcon"
    case briefcase = "BriefcaseIcon"
    case wrench = "WrenchIcon"
    case building = "BuildingIcon"
    case calendar = "CalendarIcon"
    case gift = "GiftIcon"
    case palette = "PaletteIcon"
    case cart = "CartIcon"
    case car = "CarIcon"
    case food = "FoodIcon"
    case paw = "PawIcon"
    case gameController = "GameControllerIcon"

    var id: String {
        rawValue
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
