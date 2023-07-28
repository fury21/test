import UIKit

class TopicStore {
    var topics = [String: Topic]()
    var currentTopic: Topic?
    
    init() {
        populateStore()
        currentTopic = getTopicByNumber(number: 1)
    }
    
    //следующая тема
    func getNextTopic() -> Topic? {
        guard let currentTopic = currentTopic else { return nil }
        
        let nextTopic = getTopicByNumber(number: currentTopic.number + 1)
        self.currentTopic = nextTopic
        
        return nextTopic
    }
    
    //случайнй вопрос
    public func getRandomQuestionForCurrentTopic() -> Question? {
        guard let currentTopic = currentTopic else { return nil }
        
        return getRandomQuestionByTopicName(topicName: currentTopic.name)
    }
    
    public func getRandomQuestionByTopicName(topicName: String) -> Question? {
        return topics[topicName]?.getRandomQuestion()
    }
    
    private func getTopicByNumber(number: Int) -> Topic? {
        for topic in self.topics.values {
            if (topic.number == number) {
                return topic
            }
        }
        
        return Topic(questions: [Question](), name: "", number: 0)
    }
    
    
    
    //вопросы
    private func populateStore() {
        let topicName1 = "\nТема 1\n"
        let topicName2 = "\nТема 2\n"
        
        let topicQuestions1 = [
            Question(id: "1",
                     question: "тема1вопрос1\n\n\n\n\n",
                     answer: "ответ1",
                     imageUrl: "empty",
                     explanation: "пояснение",
                     price: 1),
            Question(id: "2",
                     question: "тема1вопрос2\n\n\n\n\n",
                     answer: "ответ2",
                     imageUrl: "empty",
                     explanation: "пояснение",
                     price: 1),
            Question(id: "3",
                     question: "тема1вопрос3\n\n\n\n\n",
                     answer: "ответ3",
                     imageUrl: "empty",
                     explanation: "пояснение",
                     price: 1)
        ]
        
        let topicQuestions2 = [
            Question(id: "1",
                     question: "тема2вопрос1\n\n\n\n\n",
                     answer: "ответ1",
                     imageUrl: "empty",
                     explanation: "пояснение",
                     price: 1),
            Question(id: "2",
                     question: "тема2вопрос2\n\n\n\n\n",
                     answer: "ответ2",
                     imageUrl: "empty",
                     explanation: "пояснение", price: 1),
            Question(id: "3",
                     question: "тема2вопрос3\n\n\n\n\n",
                     answer: "ответ3",
                     imageUrl: "empty",
                     explanation: "пояснение",
                     price: 1)
        ]
        
        
        topics[topicName1] = Topic(questions: topicQuestions1,
                                   name: topicName1,
                                   number: 1)
        
        topics[topicName2] = Topic(questions: topicQuestions2,
                                   name: topicName2,
                                   number: 2)
    }
}
