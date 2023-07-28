
class Question: Codable {
    var id: String
    var question, answer, imageUrl, explanation: String
    var price: Int
    
    init(id: String, question: String, answer: String, imageUrl: String, explanation: String, price: Int) {
        self.id = id
        self.question = question
        self.answer = answer
        self.imageUrl = imageUrl
        self.explanation = explanation
        self.price = price
    }
}
