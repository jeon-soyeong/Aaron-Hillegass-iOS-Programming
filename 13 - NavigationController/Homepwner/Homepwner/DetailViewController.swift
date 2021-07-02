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
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailViewController: UITextFieldDelegate {
    
    //return키 누르면 키보드 사라지기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
