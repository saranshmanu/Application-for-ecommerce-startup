//
//  ProductsViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 02/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productName.count
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCell", for: indexPath) as! ProductsCollectionViewCell
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.productImage.image = UIImage.init(named: productCover[indexPath.row])
        cell.productLabel.text = productName[indexPath.row]
        cell.productSmallDescription.text = productSmallDescription[indexPath.row]
        if cell.productLabel.text == ""{
            cell.isUserInteractionEnabled = false
            cell.comingSoonLabel.isHidden = false
        }
        else{
            cell.isUserInteractionEnabled = true
            cell.comingSoonLabel.isHidden = true
        }
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItemNumber = indexPath.row
        print(selectedItemNumber)
    }

    @IBOutlet weak var productsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
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
