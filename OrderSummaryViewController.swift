//
//  OrderSummaryViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 23/08/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

struct delivery{
    var deliveryDate:String
    var deliveryStatus:String
}

struct finance{
    var vat:Int
    var deliveryChargesToBePaid:Int
    var amountPaidByCustomer:String
    var vatAppliedOnOrder:String
    var deliveryChargesApplied:String
    var totalCostOfProducts:String
}

class OrderSummaryViewController: UIViewController {

    @IBOutlet weak var loader: UIView!
    @IBOutlet weak var amountToBePaid: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var VAT: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    @IBOutlet weak var expectedDeliveryDate: UILabel!
    @IBOutlet weak var Country: UILabel!
    @IBOutlet weak var cityAndCountry: UILabel!
    @IBOutlet weak var firstLineAddress: UILabel!
    @IBOutlet weak var nameTextField: UILabel!
    
    func uploadToFirebase(pdfName:String, completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        let url = URL(fileURLWithPath: NSTemporaryDirectory().appending(pdfName))
        let filePath = url.appendingPathComponent(pdfName).path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: NSTemporaryDirectory().appending(pdfName)) {
            print("FILE AVAILABLE")
        } else {
            print("FILE NOT AVAILABLE")
            //unable to load all the pdf generated for the order so removing the items from cart as the pdfs are missing
            productCart.removeAll() //to update the values locally
            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/cart").setValue(nil) //to update the product dictionary online
            
            //to initiate alert
            let alertController = UIAlertController(title: "Failed to upload images!", message: "Images missing! Please place the order again! Removing items from cart!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            completionHandler(false)
            return
        }
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending(pdfName))
        // Create a root reference
        let storageRef = FIRStorage.storage().reference()
        // File located on disk
        let localFile = dst
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/" + (user?.uid)! + "/" + pdfName)
        // Upload the file to the path "images/uid/randomNameOfThePdfCreated"
        let uploadTask = riversRef.putFile(localFile, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
                completionHandler(false)
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()
                completionHandler(true)
                print(downloadURL)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        // Do any additional setup after loading the view.
        nameTextField.text = customer.name
        let date = Date().addingTimeInterval(TimeInterval(deliveryDateIncreament*24*60*60))
        let calendar = Calendar.current
        if calendar.component(.month, from: date) == 1{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "January" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 2{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "Febuary" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 3{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "March" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 4{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "April" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 5{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "May" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 6{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "June" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 7{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "July" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 8{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "August" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 9{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "September" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 10{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "October" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 11{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "November" + " " + String(calendar.component(.year, from: date))
        }
        else if calendar.component(.month, from: date) == 12{
            expectedDeliveryDate.text = String(calendar.component(.day, from: date)) + " " + "December" + " " + String(calendar.component(.year, from: date))
        }
        
        if total == 0{
            totalCost.text = String("0")
            deliveryCharges.text = String("0")
            VAT.text = String("0")
            amountToBePaid.text = String("0")
        }
        else{
            totalCost.text = String(total)
            deliveryCharges.text = String(deliveryChargesToBePaid)
            VAT.text = String((deliveryChargesToBePaid+total)*vat/100)
            amountToBePaid.text = String((deliveryChargesToBePaid+total)*vat/100 + (deliveryChargesToBePaid+total))
        }
        firstLineAddress.text = customer.address
        cityAndCountry.text = customer.state + " " + customer.pincode
        Country.text = customer.country
    }
    
    @IBOutlet weak var PaymentButton: ZFRippleButton!
    @IBAction func PaymentAction(_ sender: Any) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        loader.isHidden = false
        if productCart.count != 0 {
            for i in 0...productCart.count-1{
                uploadToFirebase(pdfName: productCart[i].productPdfName, completionHandler: {com in
                    if com == true{
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        if i == productCart.count-1{
                            self.loader.isHidden = true
                            
                            //to update the order on firebase
                            
                            //list of products ordered
                            let date = Date()
                            let calendar = Calendar.current
                            let currentDate:String = String(calendar.component(.day, from: date)) + "-" + String(calendar.component(.month, from: date)) + "-" + String(calendar.component(.year, from: date))
                            let currentTime:String = String(calendar.component(.hour, from: date)) + ":" + String(calendar.component(.minute, from: date)) + ":" + String(calendar.component(.second, from: date))
                            let currentDateAndTime:String = currentDate  + " " + currentTime
                            var orders = [NSDictionary]()
                            if productCart.count != 0{
                                for i in 0...productCart.count - 1{
                                    orders.append(["productNumber": productCart[i].productNumber, "productName":productCart[i].productName, "productCost":productCart[i].productCost, "productPdfName": productCart[i].productPdfName, "addedDate": productCart[i].addedDate])
                                }
                            }
                            
                            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/orders" + "/" + currentDateAndTime + "/Product Details").setValue(orders) //to update the order online
                            
                            //customer details at the time of ordering
                            var customerValues = ["name":customer.name, "phoneNumber":customer.phoneNumber, "address":customer.address, "city":customer.city, "pincode":customer.pincode, "state":customer.state, "country":customer.country]
                            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/orders" + "/" + currentDateAndTime + "/User Details").setValue(customerValues) //to update the order online
                            
                            //expected delivery details
                            var deliveryValues:delivery = delivery(deliveryDate:"", deliveryStatus:"")
                            deliveryValues.deliveryDate = self.expectedDeliveryDate.text!
                            deliveryValues.deliveryStatus = "Ontime Delivery"
                            
                            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/orders" + "/" + currentDateAndTime + "/Delivery Details").setValue([
                                "deliveryDate":deliveryValues.deliveryDate,
                                "deliveryStatus":deliveryValues.deliveryStatus
                                ]) //to update the order online
                            
                            //finance applied on order
                            var financeValues:finance = finance(vat:0, deliveryChargesToBePaid:0, amountPaidByCustomer:"", vatAppliedOnOrder:"", deliveryChargesApplied:"", totalCostOfProducts:"")
                            financeValues.vat = vat
                            financeValues.deliveryChargesToBePaid = deliveryChargesToBePaid
                            financeValues.totalCostOfProducts = String(total)
                            financeValues.deliveryChargesApplied = String(deliveryChargesToBePaid)
                            financeValues.vatAppliedOnOrder = String((deliveryChargesToBePaid+total)*vat/100)
                            financeValues.amountPaidByCustomer = String((deliveryChargesToBePaid+total)*vat/100 + (deliveryChargesToBePaid+total))
                            
                            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/orders" + "/" + currentDateAndTime + "/Finance Details").setValue([
                                "vat":financeValues.vat,
                                "deliveryChargesToBePaid":financeValues.deliveryChargesToBePaid,
                                "amountPaidByCustomer":financeValues.amountPaidByCustomer,
                                "vatAppliedOnOrder":financeValues.vatAppliedOnOrder,
                                "deliveryChargesApplied":financeValues.deliveryChargesApplied,
                                "totalCostOfProducts":financeValues.totalCostOfProducts
                                ]) //to update the order online
                            
                            //successfully uploaded all the pdf documents and removing the items from cart
                            productCart.removeAll() //to update the values locally
                            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/cart").setValue(nil) //to update the product dictionary online
                            
                            //to initiate alert
                            let alertController = UIAlertController(title: "Coming Soon!", message: "It was nice meeting you! We will contact soon!", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (a) in
                                //go to the home once upload is completed
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                                self.present(vc!, animated: true, completion: nil)
                            })
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    }
                    else{
                        self.loader.isHidden = true
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        //to initiate alert
                        let alertController = UIAlertController(title: "Failed to upload images!", message: "Check your internet connection!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                })
            }
        }
        else{
            print("cart empty")
            navigationController?.setNavigationBarHidden(false, animated: true)
            loader.isHidden = true
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func payment(_ sender: Any) {
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
