import UIKit

class TopicStore {
    var topics = Dictionary<String, Topic>()
    var currentTopic = Topic(questions: [Question](), name: "", number: 0)
    var favoritesTopics: [Question]?
    var mistakeTopics: [Question]?
    
    init(practiceType: PracticeType) {
        switch practiceType {
        case .tranings:
            populateStore()
            currentTopic = getTopicByNumber(number: 1)
        case .favorites:
            favoritesTopics = CoreDataManager.shared.fetchAllFavorites()
        case .errors:
            mistakeTopics = CoreDataManager.shared.fetchAllMistakes()
        }
    }
    
//следующая тема
    public func getNextTopic() -> Topic {
        let nextTopic = getTopicByNumber(number: currentTopic.number + 1)
        currentTopic = nextTopic
        return nextTopic
    }
    
//случайнй вопрос
    public func getRandomQuestionForCurrentTopic() -> Question? {
        return getRandomQuestionByTopicName(topicName: currentTopic.name)
    }
    
    public func getRandomQuestionByTopicName(topicName: String) -> Question? {
        return topics[topicName]?.getRandomQuestion()
    }
    
    private func getTopicByNumber(number: Int) -> Topic {
        for topic in self.topics.values {
            if (topic.number == number) {
                return topic
            }
        }
        
        return Topic(questions: [Question](), name: "", number: 0)
    }



//вопросы
    
    private func populateStore() {
    var topicName = "\nТема 1\n";
    var topicQuestions = [Question]()
    
        topicQuestions.append(Question(id: 0, question: "тема1вопрос1\n\n\n\n\n", answer: "ответ1", imageUrl: "empty", explanation: "пояснение", price: 1));

        topicQuestions.append(Question(id: 1, question: "тема1вопрос2\n\n\n\n\n", answer: "ответ2", imageUrl: "empty", explanation: "пояснение", price: 1));

    
        topicQuestions.append(Question(id: 2, question: "тема1вопрос3\n\n\n\n\n", answer: "ответ3", imageUrl: "empty", explanation: "пояснение", price: 1));


            self.topics[topicName] = Topic(questions: topicQuestions, name: topicName, number: 1);

        topicName = "\nТема 2\n";

        topicQuestions.append(Question(id: 3, question: "тема2вопрос1\n\n\n\n\n", answer: "ответ1", imageUrl: "empty", explanation: "пояснение", price: 1));

        topicQuestions.append(Question(id: 4, question: "тема2вопрос2\n\n\n\n\n", answer: "ответ2", imageUrl: "empty", explanation: "пояснение", price: 1));

        topicQuestions.append(Question(id: 5, question: "тема2вопрос3\n\n\n\n\n", answer: "ответ3", imageUrl: "empty", explanation: "пояснение", price: 1));


        self.topics[topicName] = Topic(questions: topicQuestions, name: topicName, number: 2);

    }
}
