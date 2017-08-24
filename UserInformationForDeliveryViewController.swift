//
//  UserInformationForDeliveryViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 05/08/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

struct userInformation {
    var name:String
    var phoneNumber:String
    var address:String
    var city:String
    var pincode:String
    var state:String
    var country:String
}
struct product{
    var productNumber:String
    var productName:String
    var productCost:String
    var productPdfName:String
    var addedDate:String
}

var customer:userInformation = userInformation(name:"", phoneNumber:"", address:"", city:"", pincode:"", state:"", country:"")
var productCart = [product]()

let user = FIRAuth.auth()?.currentUser

class UserInformationForDeliveryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    // for tapping
    func dismissKeyboard() {
        nameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        pincodeTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        var customerDictionary = ["name":nameTextField.text!, "phoneNumber":phoneNumberTextField.text!, "address":addressTextField.text!, "city":cityTextField.text!, "pincode":pincodeTextField.text!, "state":stateTextField.text!, "country":countryTextField.text!]
        print(customerDictionary)
        //Firebase update information
        FIRDatabase.database().reference().child("users/" + String(describing: user?.uid)).setValue(customerDictionary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to add the already read value at the starting of the application
        nameTextField.text = customer.name
        phoneNumberTextField.text = customer.phoneNumber
        addressTextField.text = customer.address
        cityTextField.text = customer.city
        pincodeTextField.text = customer.pincode
        stateTextField.text = customer.state
        countryTextField.text = customer.country
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserInformationForDeliveryViewController.dismissKeyboard)))
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        pincodeTextField.delegate = self
        stateTextField.delegate = self
        countryTextField.delegate = self
        
        navigationController?.navigationBar.tintColor = UIColor.black
//        navigationController?.navigationBar.barStyle = UIBarStyle.black
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
