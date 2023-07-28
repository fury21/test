import UIKit
import IQKeyboardManagerSwift

class Practic_sh_img: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var imgSh: ImageScrollView!
    @IBOutlet weak var queCheck: UITextView!
    @IBOutlet weak var inputText: UITextField!
    
    var check: String?
    var store = TopicStore()
    var rAnsw: String = ""
    var imageUrl: String = ""
    var explanation: String = ""
    
    var answer = String()
    var checkprak = UserDefaults.standard.object(forKey: "checkprak") as! Bool?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        
        imgSh.minimumZoomScale = 1.0
        imgSh.maximumZoomScale = 1.3
        imgSh.sizeToFit()
        queCheck.sizeToFit()
        
        inputText.delegate = self
        
        //сетим первый вопрос
        showQuestion()
    }
    
    //проверяем введенный ответ
    @IBAction func checkAnw(_ sender: UIButton) {
        self.view.endEditing(true)
        
        answer = inputText.text!
            .lowercased()
            .replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        //если ответ правильный/неправильный
        
        if (answer == rAnsw) {
            let alert = UIAlertController(title: "Верно", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Дальше", style: .default) { _ in
                self.showQuestion()
            })
            
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Правильный ответ - " + rAnsw, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Назад", style: .default) { _ in
                
            })
            
            alert.addAction(UIAlertAction(title: "Дальше", style: .default) { _ in
                self.showQuestion()
            })
            
            present(alert, animated: true, completion: nil)
            
        }
        
        inputText.text = ""
    }
    
    //функция отображения вопроса
    private func showQuestion() {
        guard
            let check = check,
            let question = store.getRandomQuestionByTopicName(topicName: check)
        else { return }
        
        print("Question: " + question.question + " Answer:" + question.answer)
        
        self.rAnsw = question.answer
        //            self.explanation = question.explanation
        self.imageUrl = question.imageUrl
        let myImage = UIImage (named: self.imageUrl)
        
        self.queCheck.text = question.question
        self.imgSh.display(image: myImage!)
        self.explanation = question.explanation
        
        self.setView()
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
            let offset = CGPoint.init(x: 0, y: imgSh.bounds.height)
            mytableView.setContentOffset(offset, animated: true)
        } else {
            mytableView.setContentOffset(.zero, animated: true)
        }
    }

}

