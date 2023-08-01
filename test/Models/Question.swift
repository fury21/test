
class Question {
    
    var id: Int
    var question, answer, imageUrl, explanation : String
    var price : Int
    
    init(id: Int, question: String, answer: String, imageUrl: String, explanation: String, price: Int) {
        
        self.id = id
        self.question = question
        self.answer = answer
        self.imageUrl = imageUrl
        self.explanation = explanation
        self.price = price
    }
    
    init(questionModel: QuestionModel) {
        self.id = Int(questionModel.id)
        self.question = questionModel.question ?? ""
        self.answer = questionModel.answer ?? ""
        self.imageUrl = questionModel.imageUrl ?? ""
        self.explanation = questionModel.explanation ?? ""
        self.price = Int(questionModel.price)
    }
    
}
