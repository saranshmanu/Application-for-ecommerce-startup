//
//  LoginViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 01/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase
import Answers

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var background: ZFRippleButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButton(_ sender: Any) {
        self.view.layoutIfNeeded()
        loginButton.isEnabled = false
        username.isEnabled = false
        password.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.activityIndicator.isHidden = false
        })
        FIRAuth.auth()?.signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            if error == nil{
                print("Login Successfull")
                self.fetchUserDataFromFirebase(sample: "", completionHandler: {com in
                    if com == true{
                        self.activityIndicator.isHidden = true
                        self.loginButton.isEnabled = true
                        self.username.isEnabled = true
                        self.password.isEnabled = true
                        //Go to the HomeViewController if the login is sucessful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    else{
                        print("Failed to retreive data")
                    }
                })
            }
            else{
                self.activityIndicator.isHidden = true
                self.loginButton.isEnabled = true
                self.username.isEnabled = true
                self.password.isEnabled = true
                print("Login Unsuccessfull")
                //to initiate alert if login is unsuccesfull
                let alertController = UIAlertController(title: "Try Again", message: "Incorrect username or password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    func fetchUserDataFromFirebase(sample:String, completionHandler: @escaping ((_ exist : Bool) -> Void)){
        FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/profile").observeSingleEvent(of: .value , with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                customer.name = value["name"]! as! String
                customer.phoneNumber = value["phoneNumber"]! as! String
                customer.address = value["address"]! as! String
                customer.city = value["city"]! as! String
                customer.pincode = value["pincode"]! as! String
                customer.state = value["state"]! as! String
                customer.country = value["country"]! as! String
                print(value)
                print(customer)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/profile").observe(.childChanged, with: {_ in
            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/profile").observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! NSDictionary
                customer.name = value["name"] as! String
                customer.phoneNumber = String(describing: value["phoneNumber"]!)
                customer.address = String(describing: value["address"]!)
                customer.city = String(describing: value["city"]!)
                customer.pincode = String(describing: value["pincode"]!)
                customer.state = String(describing: value["state"]!)
                customer.country = String(describing: value["country"]!)
                print(value)
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/cart").observeSingleEvent(of: .value , with: { (snapshot) in
            // Get user value
            completionHandler(true)
            if let value = snapshot.value as? [NSDictionary]{
                if value.count != 0{
                    for i in 0...value.count - 1 {
                        productCart.append(product(productNumber: String(describing: value[i]["productNumber"]!), productName:String(describing: value[i]["productName"]!), productCost:String(describing: value[i]["productCost"]!), productPdfName: String(describing: value[i]["productPdfName"]!), addedDate: String(describing: value[i]["addedDate"]!)))
                    }
                }
                print(productCart)
            }
            // ...
        }) { (error) in
            completionHandler(false)
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        username.layer.cornerRadius = username.frame.height/2
        username.attributedPlaceholder = NSAttributedString(string: username.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        password.layer.cornerRadius = password.frame.height/2
        password.attributedPlaceholder = NSAttributedString(string: password.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    // for tapping
    func dismissKeyboard() {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var initialCenter: CGFloat = 0.0
    var constant:CGFloat = 150.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.topConstraint.constant -= self.constant
            self.bottomConstraint.constant += self.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(self.username.isEditing || self.password.isEditing) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.topConstraint.constant += self.constant
                self.bottomConstraint.constant -= self.constant
                self.view.layoutIfNeeded()
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "App started", customAttributes: ["platform":"ios"])
        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
        username.delegate = self
        password.delegate = self
        // for tapping
        self.background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
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
