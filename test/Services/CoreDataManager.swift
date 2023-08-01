import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var viewContext = persistentContainer.viewContext
    
    
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuestionsStorage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("\nERROR: Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("\nERROR in func \(#function):", error.localizedDescription)
            }
        }
    }
    
    func addToFavorite(question: Question) {
        let questionModel = QuestionModel(context: viewContext)
        
        questionModel.id = Int64(question.id)
        questionModel.question = question.question
        questionModel.answer = question.answer
        questionModel.imageUrl = question.imageUrl
        questionModel.explanation = question.explanation
        questionModel.price = Int64(question.price)
        questionModel.isFavorite = true
        questionModel.isMistake = false
        
        saveContext()
    }
    
    func removeFromFavorite(questionID: Int) {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "id = %d AND isFavorite = %@", questionID, NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            if let question = result.first {
                viewContext.delete(question)
            }
            
            saveContext()
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
        }
    }
    
    func isFavorite(questionID: Int) -> Bool {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "id = %d AND isFavorite = %@", questionID, NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            if let _ = result.first {
                return true
            } else {
                return false
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
            return false
        }
    }
    
    func fetchAllFavorites() -> [Question]? {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite = %@", NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            let questions = results.map { Question(questionModel: $0) }
            
            if questions.count > 0 {
                return questions
            } else {
                return nil
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
            return nil
        }
    }
    
    func printAllFavorites() {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite = %@", NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            
            if results.count > 0 {
                print("\nAll favorites:")
                results.forEach { print($0.id, $0.question, $0.isFavorite) }
            } else {
                print("\nFavorites is empty")
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
        }
    }
    
    func addToMistake(question: Question, count: Int) {
        let questionModel = QuestionModel(context: viewContext)
        
        questionModel.id = Int64(question.id)
        questionModel.question = question.question
        questionModel.answer = question.answer
        questionModel.imageUrl = question.imageUrl
        questionModel.explanation = question.explanation
        questionModel.price = Int64(question.price)
        questionModel.isFavorite = false
        questionModel.isMistake = true
        questionModel.mistakeCount = Int64(count)
        
        saveContext()
    }
    
    func removeFromMistakes(questionID: Int) {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "id = %d AND isMistake = %@", questionID, NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            if let question = result.first {
                viewContext.delete(question)
            }
            
            saveContext()
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
        }
    }
    
    func mistakeIsExist(questionID: Int) -> Int? {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "id = %d AND isMistake = %@", questionID, NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            if let count = result.first?.mistakeCount {
                return Int(count)
            } else {
                return nil
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
            return nil
        }
    }
    
    func fetchMistakeCount(questionID: Int) -> Int? {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "id = %d AND isMistake = %@", questionID, NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            if let count = result.first?.mistakeCount {
                return Int(count)
            } else {
                return nil
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
            return nil
        }
    }
    
    func editMistakeCount(questionID: Int, count: Int) {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "id = %d AND isMistake = %@", questionID, NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            
            if let question = result.first {
                return question.mistakeCount = Int64(count)
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
            return
        }
    }
    
    func fetchAllMistakes() -> [Question]? {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "isMistake = %@", NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            let questions = results.map { Question(questionModel: $0) }
            
            if questions.count > 0 {
                return questions
            } else {
                return nil
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
            return nil
        }
    }
    
    func printAllMistakes() {
        let fetchRequest = QuestionModel.fetchRequest()
        let predicate = NSPredicate(format: "isMistake = %@", NSNumber(value: true))
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            
            if results.count > 0 {
                print("\nAll mistakes:")
                results.forEach { print($0.id, $0.question, $0.isMistake, $0.mistakeCount) }
                print("\n")
            } else {
                print("Mistakes is empty\n")
            }
        } catch let error {
            print("\nERROR in func \(#function):", error.localizedDescription)
        }
    }
    
    
}
