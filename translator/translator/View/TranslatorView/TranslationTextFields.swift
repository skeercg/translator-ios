
import UIKit

extension TranslatorView: UITextViewDelegate {    
    func setupSourceLanguageTextField(translationRegion: UIView) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.systemGray6
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexible, doneButton], animated: false)
        
        let sourceLanguageTextView = UITextView()
        sourceLanguageTextView.inputAccessoryView = toolbar
        sourceLanguageTextView.isEditable = true
        sourceLanguageTextView.isScrollEnabled = false
        sourceLanguageTextView.backgroundColor = .clear
        sourceLanguageTextView.font = UIFont.systemFont(ofSize: 36)
        sourceLanguageTextView.text = "Enter text"
        sourceLanguageTextView.textColor = UIColor(hex: 0x8e918e)
        sourceLanguageTextView.translatesAutoresizingMaskIntoConstraints = false
        sourceLanguageTextView.delegate = self
        
        self.sourceLanguageTextView = sourceLanguageTextView
        
        translationRegion.addSubview(sourceLanguageTextView)
        
        NSLayoutConstraint.activate([
            sourceLanguageTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            
            sourceLanguageTextView.leadingAnchor.constraint(equalTo: translationRegion.leadingAnchor, constant: 16),
            sourceLanguageTextView.trailingAnchor.constraint(equalTo: translationRegion.trailingAnchor, constant: -16),
        ])
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textView = sourceLanguageTextView {
            if textView.textColor == UIColor(hex: 0x8e918e) {
                textView.text = nil
                textView.textColor = UIColor(hex: 0xfefbfa)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let textView = sourceLanguageTextView {
            if textView.text.isEmpty {
                textView.text = "Enter text"
                textView.textColor = UIColor(hex: 0x8e918e)
            }
        }
    }
    
    @objc func doneButtonTapped() {
        if let textView = sourceLanguageTextView {
            textView.resignFirstResponder()
        }
    }
}
