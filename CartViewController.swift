//
//  CartViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 02/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

var total = 0

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productCart.count
    }
    
    @IBOutlet weak var cartEmptyLabel: UILabel!
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartTableCell", for: indexPath as IndexPath) as! CartTableViewCell
        cell.productImage.layer.cornerRadius = cell.productImage.frame.height / 2
        cell.productImage.image = UIImage.init(named : productCover[(productCart[indexPath.row].productNumber as NSString).integerValue])
        cell.productLabel.text = productCart[indexPath.row].productName
        cell.pricingLabel.text = productCart[indexPath.row].productCost
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cartTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let remove = UIAlertAction(title: "Remove", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            productCart.remove(at: indexPath.row)
            print("Removed from cart")
            self.cartTableView.reloadData()
            self.calculateTotalPrice()
            self.totalPrice.text = String(total)
            if productCart.count == 0{
                self.cartEmptyLabel.isHidden = false
            }
            var cart = [NSDictionary]()
            if productCart.count != 0{
                for i in 0...productCart.count - 1{
                    cart.append(["productNumber": productCart[i].productNumber, "productName":productCart[i].productName, "productCost":productCart[i].productCost, "productPdfName": productCart[i].productPdfName, "addedDate": productCart[i].addedDate])
                }
            }
            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/cart").setValue(cart)
        })
        optionMenu.addAction(remove)
        optionMenu.addAction(defaultAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    func calculateTotalPrice(){
        total = 0
        if productCart.count != 0{
            for i in 0...(productCart.count-1){
                total += (productCart[i].productCost as NSString).integerValue
            }
            cartEmptyLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cartTableView.delegate = self
        cartTableView.dataSource = self
        checkoutButton.layer.cornerRadius = checkoutButton.frame.height/2
        calculateTotalPrice()
        totalPrice.text = String(total)
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
