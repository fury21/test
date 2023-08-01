import Foundation

enum PracticeType {
    case tranings
    case favorites
    case errors
    
    var title: String {
        switch self {
        case .tranings:
            return "Тренировка"
        case .favorites:
            return "Избранное"
        case .errors:
            return "Ошибки"
        }
    }
    
    var userDefaultsKey: String {
        switch self {
        case .errors:
            return "userDefaultsErrorsKey"
        case .favorites:
            return "userDefaultsFavoritesKey"
        case .tranings:
            return "userDefaultsTraningsKey"
        }
    }
    
}
