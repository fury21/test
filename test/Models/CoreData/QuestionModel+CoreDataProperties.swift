import Foundation
import CoreData


extension QuestionModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionModel> {
        return NSFetchRequest<QuestionModel>(entityName: "QuestionModel")
    }

    @NSManaged public var question: String?
    @NSManaged public var answer: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var explanation: String?
    @NSManaged public var price: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isMistake: Bool
    @NSManaged public var mistakeCount: Int64
    @NSManaged public var id: Int64

}
