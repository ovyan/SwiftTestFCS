//
//  EnterVC.swift
//  FKN_Final_Ovyan
//
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import UIKit

class EnterVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    weak var d: NewVCDelegate?

    @IBOutlet var titleText: UITextField!

    @IBOutlet var descriptionText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionText.layer.borderWidth = 0.5
        descriptionText.layer.borderColor = borderColor.cgColor
        descriptionText.layer.cornerRadius = 5.0
        titleText.delegate = self
        descriptionText.delegate = self
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func fuck(_ sender: Any) {
        d?.didCreateTask(with: titleText.text ?? "No_name", other: descriptionText.text)
        navigationController?.popViewController(animated: true)
    }
}
