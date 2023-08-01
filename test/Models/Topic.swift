

class Topic {
    var questions : Array<Question>
    var name : String
    var number : Int
    
    init(questions:Array<Question>, name:String, number:Int) {
        self.questions = questions
        self.name = name
        self.number = number
    }
    
    public func getRandomQuestion() -> Question {
        return questions.randomElement() ?? Question(id: 0, question: "Question", answer: "Answer", imageUrl: "Image", explanation: "Explanation", price: 1)
    }
}
