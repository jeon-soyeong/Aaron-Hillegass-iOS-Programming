//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by 전소영 on 2021/06/15.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        } else {
            return nil
        }
    }
    
    let numberFomatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        guard let currentTime = Int(dateFormatter.string(from: Date())) else {
            return
        }
        print(currentTime)
        
        if currentTime > 18, currentTime < 6 {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            //            celsiusLabel.text = "\(value)"
            celsiusLabel.text = numberFomatter.string(from: NSNumber(value: value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        print("Current text: \(textField.text)")
        //        print("Replacement text : \(string)")
        //
        //        return true
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        let charactersNotAllowed = NSCharacterSet.letters
        let replacementTextHasLetter = string.rangeOfCharacter(from: charactersNotAllowed)
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        } else if replacementTextHasLetter != nil {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        //        if let text = textField.text, !text.isEmpty {
        //            celsiusLabel.text = textField.text
        //        } else {
        //            celsiusLabel.text = "???"
        //        }
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = value
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        textField.resignFirstResponder()
    }
}
