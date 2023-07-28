class Topic: Codable {
    var questions: [Question]
    var name: String
    var number: Int
    
    init(questions: [Question], name: String, number: Int) {
        self.questions = questions
        self.name = name
        self.number = number
    }
    
    func getRandomQuestion() -> Question? {
        return questions.randomElement()
    }
}
