import UIKit

extension UIViewController {
    
    /// Показывает настраиваемый alert с текстом
    /// - Parameters:
    ///   - title: заголовок
    ///   - message: сообщение
    ///   - isCancelButton: нужна ли кнопка "отмена" или только "ок"
    ///   - isOkDestructive: кнопка "Ок" красного цвета
    ///   - okButtonName: название кнопки "Ок"
    ///   - buttonsArray: добавить свой массив кнопок
    ///   - preferredStyle: стиль отображения
    ///   - sourceView: передать кнопку для отображения алерта около нее (для iPad)
    ///   - completion: замыкание для кнопки "Ок"
    func showAlert(title: String,
                   message: String,
                   isCancelButton: Bool? = nil,
                   isOkDestructive: Bool? = nil,
                   okButtonName: String? = nil,
                   customButtons: [UIAlertAction] = [UIAlertAction](),
                   preferredStyle: UIAlertController.Style = .alert,
                   sourceView: UIView? = nil,
                   completion: (() -> Void)? = nil) {
        
        showAlert(type: .alert(title: title,
                               message: message),
                  isCancelButton: isCancelButton,
                  isOkDestructive: isOkDestructive,
                  okButtonName: okButtonName,
                  customButtons: customButtons,
                  preferredStyle: preferredStyle,
                  sourceView: sourceView,
                  completion: completion)
    }
    
    /// Показывает настраиваемый alert с текстом
    ///
    /// По умолчанию всегда доступна одна кнопка "Ок"
    ///
    /// - Parameters:
    ///   - type: .alert - это обычный алерт с title и message. .error - передается ошибка из которой берутся все данные (titile и message) для показа алерта
    ///   - isCancelButton: нужна ли кнопка "отмена" или только "ок"
    ///   - isOkDestructive: кнопка "Ок" красного цвета
    ///   - okButtonName: название кнопки "Ок"
    ///   - customButtons: добавить свой массив кнопок
    ///   - preferredStyle: стиль отображения
    ///   - sourceView: передать кнопку для отображения алерта около нее (для iPad)
    ///   - completion: замыкание для кнопки "Ок"
    func showAlert(type: AlertType,
                   isCancelButton: Bool? = nil,
                   isOkDestructive: Bool? = nil,
                   okButtonName: String? = nil,
                   customButtons: [UIAlertAction] = [UIAlertAction](),
                   preferredStyle: UIAlertController.Style = .alert,
                   sourceView: UIView? = nil,
                   completion: (() -> Void)? = nil) {
        
        let okDefaultName = "Ок"
        let cancelDefaultName = "Отмена"
        
        func addActionSheetForiPad(actionSheet: UIAlertController) {
            if let popoverPresentationController = actionSheet.popoverPresentationController, let sourceView = sourceView {
                popoverPresentationController.sourceView = sourceView
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.permittedArrowDirections = [.down, .up]
            }
        }
        
        
        var alert = UIAlertController()
        
        switch type {
        case .alert(let title, let message):
            alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        case .localizedError(let error):
            let title = error.errorDescription
            let message = [
                error.failureReason,
                error.recoverySuggestion
            ].compactMap { $0 }
                .joined(separator: "\n\n")
            
            alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        case .NSError(let error):
            let title = "Ошибка!"
            let message = [
                error.localizedDescription,
                error.localizedFailureReason,
                error.localizedRecoverySuggestion
            ].compactMap { $0 }
                .joined(separator: "\n\n")
            
            alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        }
        
        var allButtons = [UIAlertAction]()
        
        if let okButtonName = okButtonName { //}, !okButtonName!.isEmpty {  //}, isOkDestructive != nil, isOkDestructive! {
            let name = okButtonName.isEmpty ? okDefaultName : okButtonName
            let style: UIAlertAction.Style = isOkDestructive == true ? .destructive : .default
            
            allButtons.append(UIAlertAction(title: name, style: style) { (_) in
                completion?()
            })
        }
        
        
        if !customButtons.isEmpty {
            allButtons += customButtons
        }
        
        if isCancelButton == true {
            // Когда preferredStyle == .cancel, то две дефолыне кнопки Ок и Отмена меняются местами
            let style: UIAlertAction.Style = preferredStyle == .alert ? .default : .cancel
            
            allButtons.append(UIAlertAction(title: cancelDefaultName, style: style))
        }
        
        for button in allButtons {
            alert.addAction(button)
        }
        
        if allButtons.isEmpty {
            alert.addAction(UIAlertAction(title: okDefaultName, style: .cancel) { (_) in
                completion?()
            })
        }
        
        addActionSheetForiPad(actionSheet: alert)
        
        present(alert, animated: true)
    }
    
    enum AlertType {
        /// Обычный Алерт с title и message
        case alert(title: String, message: String)
        /// Title берется из error.errorDescription, а message из error.failureReason + error.recoverySuggestion
        case localizedError(LocalizedError)
        case NSError(NSError)
    }
    
}
