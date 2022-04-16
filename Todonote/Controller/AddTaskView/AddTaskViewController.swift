//
//  AddTaskViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 10.04.2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTask: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTask: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //MARK: - vars/lets
    var activeTextField: UITextField? = nil
    var viewModel = AddTaskViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTask.delegate = self
        noteTask.delegate = self
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - IBActions
    private func updateUI() {
        bottomView.layer.cornerRadius = 20
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        saveButton.layer.cornerRadius = 10
    }
    
    @IBAction func noteAdd(_ sender: UITextField) {
       
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if viewModel.saveTask(title: titleTask.text ?? "", date: datePicker.date, note: noteTask.text ?? "") {
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Add some title", message: "", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }

    }
    
    private func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

     @IBAction  func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
         
         var shoulMoveViewUp = false
         
         if let activeTextField = activeTextField {
             
             let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
             let topOfKeyboard = self.view.frame.height - keyboardScreenEndFrame.height
             
             if bottomOfTextField > topOfKeyboard {
                 shoulMoveViewUp = true
             }
         }
         
         if shoulMoveViewUp {
            if notification.name == UIResponder.keyboardWillShowNotification {
                topConstraint.constant -= keyboardScreenEndFrame.height
                bottomConstraint.constant = keyboardScreenEndFrame.height
            }

         }
         
         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
        
    }

}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.activeTextField = nil
        topConstraint.constant = 0
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
