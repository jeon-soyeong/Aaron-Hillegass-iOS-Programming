//
//  DetailViewController.swift
//  Homepwner
//
//  Created by 전소영 on 2021/07/01.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    
    var item: Item? {
        didSet {
            navigationItem.title = item?.name
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let item = item {
            nameField.text = item.name
            serialNumberField.text = item.serialNumber
            valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
            dateLabel.text = dateFormatter.string(from: item.dateCreated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //퍼스트 리스폰더를 정리한다.
        view.endEditing(true)
        
        if let item = item {
            // "Save" changes to item
            item.name = nameField.text ?? ""
            item.serialNumber = serialNumberField.text
            
            if let valueText = valueField.text,
               let value = numberFormatter.number(from: valueText) {
                item.valueInDollars = value.intValue
            }
            else {
                item.valueInDollars = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        valueField.delegate = self
        serialNumberField.delegate = self
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension DetailViewController: UITextFieldDelegate {
    
    //return키 누르면 키보드 사라지기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


@IBDesignable
class CustomtextField: UITextField {
    let border = CALayer()
    let width = CGFloat(2.0)
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height:self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        border.borderColor = UIColor.clear.cgColor
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

        return true
    }
}
