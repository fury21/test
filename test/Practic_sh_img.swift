


import UIKit
import IQKeyboardManagerSwift

class Practic_sh_img: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var imgSh: ImageScrollView!
    @IBOutlet weak var queCheck: UITextView!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var practiceType = PracticeType.tranings
    
    var currentQuestion: Question!
    var check: String = "qwe"
    lazy var store = TopicStore(practiceType: practiceType)
    var rAnsw: String = ""
    var imageUrl: String = ""
    var explanation: String = ""
    
    var answer = String()
    var checkprak = UserDefaults.standard.object(forKey: "checkprak") as! Bool?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        
        self.inputText.delegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        
        self.imgSh.minimumZoomScale = 1.0
        self.imgSh.maximumZoomScale = 1.3
        
        //сетим первый вопрос
       showQuestion()
    }
    
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            CoreDataManager.shared.removeFromFavorite(questionID: currentQuestion.id)
        } else {
            CoreDataManager.shared.addToFavorite(question: currentQuestion)
        }
        
        sender.isSelected.toggle()
    }
    
    
    //проверяем введенный ответ
    @IBAction func checkAnw(_ sender: UIButton) {
        self.view.endEditing(true)
        
        answer = inputText.text!
        answer = answer.lowercased()
        answer = answer.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)

        //если ответ правильный/неправильный
        if (answer == rAnsw) {
            let alert = UIAlertController(title: "Верно", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Дальше", style: UIAlertAction.Style.default, handler: { ACTION in

                self.showQuestion()

            }))
            
            self.present(alert, animated: true, completion: nil)
            
            if practiceType == .errors {
                if let count = CoreDataManager.shared.mistakeIsExist(questionID: currentQuestion.id) {
                    if count == 1 {
                        CoreDataManager.shared.removeFromMistakes(questionID: currentQuestion.id)
                    } else {
                        CoreDataManager.shared.editMistakeCount(questionID: currentQuestion.id,
                                                                count: count - 1)
                    }
                } else {
                    CoreDataManager.shared.addToMistake(question: currentQuestion, count: 2)
                }
            }
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Правильный ответ - " + rAnsw, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Назад", style: UIAlertAction.Style.default, handler: { ACTION in
            }))
            alert.addAction(UIAlertAction(title: "Дальше", style: UIAlertAction.Style.default, handler: { ACTION in

                self.showQuestion()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            if practiceType == .tranings {
                if let _ = CoreDataManager.shared.mistakeIsExist(questionID: currentQuestion.id) {
                    CoreDataManager.shared.editMistakeCount(questionID: currentQuestion.id, count: 3)
                } else {
                    CoreDataManager.shared.addToMistake(question: currentQuestion, count: 3)
                }
            }
        }
        
        inputText.text = ""
    }
    
//функция отображения вопроса
    private func showQuestion() {
        var question: Question?
        
        switch practiceType {
        case .tranings:
           question = store.getRandomQuestionByTopicName(topicName: check)
        case .favorites:
            question = store.favoritesTopics?.randomElement()
        case .errors:
            store.mistakeTopics = CoreDataManager.shared.fetchAllMistakes()
            question = store.mistakeTopics?.randomElement()
        }
        
        
        guard let question = question else {
            showEmptyScreen()
            return
        }
        
        currentQuestion = question
        print("Question: " + question.question + " Answer:" + question.answer)
        self.rAnsw = question.answer
        //            self.explanation = question.explanation
        self.imageUrl = question.imageUrl
        var myImage = UIImage (named: self.imageUrl)
        
        self.queCheck.text = question.question
        self.imgSh.display(image: myImage!)
        self.explanation = question.explanation
        
        favoriteButton.isSelected = CoreDataManager.shared.isFavorite(questionID: question.id)
        
        imgSh.sizeToFit()
        queCheck.sizeToFit()
        
        self.setView()
    }
    
    private func showEmptyScreen() {
        guard
            let emptyView = Bundle.main.loadNibNamed("EmptyScreenView",
                                                     owner: nil,
                                                     options: nil)?.first as? EmptyScreenView
        else { return }
        
        switch practiceType {
        case .tranings:
            emptyView.titleLabel.text = "Вопросов нет"
        case .favorites:
            emptyView.titleLabel.text = "В избранном ничего нет"
        case .errors:
            emptyView.titleLabel.text = "Ошибок нет"
        }
        
        view.addSubview(emptyView)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
    
    func setView() {
        if imageUrl == "empty" {
            let offset = CGPoint.init(x: 0, y: self.imgSh.bounds.height)
            self.mytableView.setContentOffset(offset, animated: true)
        } else {
            self.mytableView.setContentOffset(.zero, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

