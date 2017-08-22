//
//  CartViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 02/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    @IBOutlet weak var cartEmptyLabel: UILabel!
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartTableCell", for: indexPath as IndexPath) as! CartTableViewCell
        cell.productImage.layer.cornerRadius = cell.productImage.frame.height / 2
        cell.productImage.image = UIImage.init(named: "ProductOne")
        cell.productLabel.text = productName[cart[indexPath.row]]
        cell.pricingLabel.text = productPriceOfTheItem[cart[indexPath.row]]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cartTableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        checkoutButton.layer.cornerRadius = checkoutButton.frame.height/2
        var total = 0
        if cart.count != 0{
            for i in 0...(cart.count-1){
                total += (productPriceOfTheItem[cart[i]] as NSString).integerValue
            }
            cartEmptyLabel.isHidden = true
        }
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
