import Foundation

extension UserDefaults {
    
    private var userDefaultsQuestionKey: String {
        return String(describing: self)
    }
    
    func getFavorites() -> [Topic]? {
        guard
            let decoded = UserDefaults.standard.data(forKey: userDefaultsQuestionKey)
        else { return nil }
        
        let topics = try? JSONDecoder().decode([Topic].self, from: decoded)
        
        return topics
    }
    
    
    func add(topic: Topic) {
        if let favoriteTopics = getFavorites(),
           let currentTopic = favoriteTopics.first(where: { thisTopic in
               thisTopic.number == topic.number
           }) {
            topic.questions.forEach { addTopic in
                if !currentTopic.questions.contains(where: { thisQuestion in
                    thisQuestion.id == addTopic.id
                }) {
                    currentTopic.questions.append(addTopic)
                }
            }
            
            guard let encodedData = try? JSONEncoder().encode(currentTopic) else { return }
            
            UserDefaults.standard.set(encodedData, forKey: userDefaultsQuestionKey)
        } else {
            guard let encodedData = try? JSONEncoder().encode(topic) else { return }
            
            UserDefaults.standard.set(encodedData, forKey: userDefaultsQuestionKey)
        }
    }
    
    func removeTopic(id: Int) {
        guard var favoriteTopics = getFavorites() else { return }
        
        favoriteTopics.removeAll { thisTopic in
            thisTopic.number == id
        }
        
        guard let encodedData = try? JSONEncoder().encode(favoriteTopics) else { return }
        
        UserDefaults.standard.set(encodedData, forKey: userDefaultsQuestionKey)
    }
    
    func removeQuestion(topicID: Int, questrionID: String) {
        guard var favoriteTopics = getFavorites() else { return }
        
        if let currentTopic = favoriteTopics.first(where: { thisTopic in
            thisTopic.number == topicID
        }) {
            currentTopic.questions.removeAll { thisQuestion in
                thisQuestion.id == questrionID
            }
        }
        
        guard let encodedData = try? JSONEncoder().encode(favoriteTopics) else { return }
        
        UserDefaults.standard.set(encodedData, forKey: userDefaultsQuestionKey)
    }
    
}
