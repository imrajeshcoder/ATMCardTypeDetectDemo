//
//  ViewController.swift
//  ATMCardTypeDetectDemo
//
//  Created by Vijay on 21/07/21.
//

import UIKit
import Stripe
import CreditCardForm

class ViewController: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var placeHolderView: UIView!
    @IBOutlet weak var viewBOttumView: UIView!
    @IBOutlet weak var lblCardHolderName: UILabel!
    @IBOutlet weak var lblExpireDate: UIView!
    
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtExpireDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var btbSaveCardForFuture: UIButton!
    @IBOutlet weak var viewCreditUserInputView: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet var viewMainContainer: UIView!
    
    @IBOutlet weak var viewCreditCardView: UIView!
    @IBOutlet weak var creditCardForm: CreditCardFormView!
    // Stripe textField
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.applyTheme(theme: .dark)
        let theme = ThemeManager.currentTheme()
        
        viewMainContainer.backgroundColor = theme.mainColor
        placeHolderView.backgroundColor = theme.mainColor
        creditCardForm.backgroundColor = theme.mainColor
        viewCreditUserInputView.backgroundColor = theme.creditCardViewColor
        txtCardNumber.textColor = theme.textBoxTextColor
        txtCardHolderName.textColor = theme.textBoxTextColor
        txtExpireDate.textColor = theme.textBoxTextColor
        txtCVV.textColor = theme.textBoxTextColor
        btbSaveCardForFuture.tintColor = theme.buttonTintColor
        self.view.backgroundColor = theme.backgroundColor
        
        
        
        var normalText = "Hi am normal"
        
        var boldText  = "And I am BOLD!"
        
        var lblAttributedString =  NSMutableAttributedString(string: "Total: ", attributes:[NSAttributedString.Key.foregroundColor : theme.textBoxTextColor ] )
        
        lblAttributedString.append(NSMutableAttributedString(string: "499 ", attributes:[NSAttributedString.Key.foregroundColor : UIColor.darkGray ] ))
        
        lblTotal.attributedText = lblAttributedString
        
        viewBOttumView.setShadow(width: 0, height: 2, color: UIColor.lightGray, radius: 5, opacity: 5)
        
        txtCardNumber.delegate  = self
        txtExpireDate.delegate = self
        txtCVV.delegate = self
        txtCardHolderName.delegate = self
        self.txtCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        self.txtExpireDate.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        
        creditCardForm.maskToBounds = true
        creditCardForm.chipImage = UIImage()
        
        
        creditCardForm.cardNumberFont =  UIFont.systemFont(ofSize: 18.0)
        addDoneButtonOnKeyboard()
        
    }
    
    @IBAction func txtDateChange(_ sender: UITextField) {
        var trimmedString = sender.text!
        trimmedString = trimmedString.components(separatedBy: "/").joined()
        let month = trimmedString.prefix(2)
        
        let year = trimmedString.count > 3 ? trimmedString.suffix(2) : trimmedString.count > 2 ? trimmedString.suffix(1) : "00"
        
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: txtCardNumber.text!, expirationYear:  UInt(year), expirationMonth:  UInt(month), cvc: txtCVV.text!)
    }
    @IBAction func cardHolderNameChange(_ sender: UITextField) {
        creditCardForm.cardHolderString = sender.text!
    }
    @IBAction func txtNumberChange(_ sender: UITextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: txtCardNumber.text!, expirationYear:  UInt(txtExpireDate.text!), expirationMonth:  UInt(txtExpireDate.text!), cvc: txtCVV.text!)
    }
    @IBAction func cvvChange(_ sender: UITextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: txtCardNumber.text!, expirationYear:  UInt(txtExpireDate.text!), expirationMonth:  UInt(txtExpireDate.text!), cvc: txtCVV.text!)
    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear:  UInt(textField.expirationYear), expirationMonth:  UInt(textField.expirationMonth), cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidEndEditingCVC()
    }
    @IBAction func btnSaveCardForFuter(_ sender: UIButton) {
        btbSaveCardForFuture.isSelected.toggle()
        
    }
}


extension ViewController{
    //MARK:- Card Number Format
    @objc func didChangeText(textField:UITextField) {
        textField.text = self.modifyCreditCardString(textField: textField)
    }
    func modifyCreditCardString(textField:UITextField) -> String {
        var trimmedString = textField.text!.components(separatedBy: .whitespaces).joined()
        
        
        var modifiedCreditCardString = ""
        
        var appendChar: String
        
        switch textField {
        case txtCardNumber:
            
            let arrOfCharacters = Array(trimmedString)
            if(arrOfCharacters.count > 0) {
                for i in 0...arrOfCharacters.count-1 {
                    modifiedCreditCardString.append(arrOfCharacters[i])
                    if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                        modifiedCreditCardString.append(" ")
                    }
                }
            }
            break
        case txtExpireDate:
            trimmedString = trimmedString.components(separatedBy: "/").joined()
            let arrOfCharacters = Array(trimmedString)
            if(arrOfCharacters.count > 0) {
                for i in 0...arrOfCharacters.count-1 {
                    modifiedCreditCardString.append(arrOfCharacters[i])
                    if((i+1) % 2 == 0 && i+1 != arrOfCharacters.count){
                        modifiedCreditCardString.append("/")
                    }
                }
            }
            break
        default:
            break
        }
        return modifiedCreditCardString
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == txtCardNumber) {
            return newLength <= 19
        }
        else if (textField == txtExpireDate){
            return newLength <= 5
        }
        else if (textField == txtCVV){
            return newLength <= 3
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtCardNumber.inputAccessoryView = doneToolbar
        txtExpireDate.inputAccessoryView = doneToolbar
        txtCVV.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        txtCardNumber.resignFirstResponder()
        txtExpireDate.resignFirstResponder()
        txtCVV.resignFirstResponder()
    }
}


