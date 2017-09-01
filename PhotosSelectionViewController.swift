//
//  PhotosSelectionViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 22/08/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import OpalImagePicker
import PDFGenerator
import Firebase

var selectedImageForEditing = UIImage.init(named : "")
var selectedImageNumber = 0
var photos = [UIImage]()

func randomString(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

class PhotosSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, OpalImagePickerControllerDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    let imagePicker = OpalImagePickerController()
    let pdfName = randomString(length: 15)
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidAppear(_ animated: Bool) {
        selectedPhotos.reloadData()
    }
    
    func generatePDF() {
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending(pdfName))
        // outputs as Data
        do {
            let data = try PDFGenerator.generated(by: photos)
            try data.write(to: dst, options: .atomic)
            print("output completed")
        } catch (let error) {
            print(error)
        }
        // writes to Disk directly.
        do {
            try PDFGenerator.generate(photos, to: dst)
            print("write completed")
//            webView.loadRequest(URLRequest(url: dst))
            var cart = [NSDictionary]()
            //to get the current date and time
            let date = Date()
            let calendar = Calendar.current
            let currentDate:String = String(calendar.component(.day, from: date)) + "/" + String(calendar.component(.month, from: date)) + "/" + String(calendar.component(.year, from: date))
            let currentTime:String = String(calendar.component(.hour, from: date)) + ":" + String(calendar.component(.minute, from: date)) + ":" + String(calendar.component(.second, from: date))
            let currentDateAndTime:String = currentDate  + " " + currentTime
            productCart.append(product(productNumber: String(selectedItemNumber), productName:productName[selectedItemNumber], productCost:productPriceOfTheItem[selectedItemNumber], productPdfName: pdfName, addedDate: currentDateAndTime))
            if productCart.count != 0{
                for i in 0...productCart.count - 1{
                    cart.append(["productNumber": productCart[i].productNumber, "productName":productCart[i].productName, "productCost":productCart[i].productCost, "productPdfName": productCart[i].productPdfName, "addedDate": productCart[i].addedDate])
                }
            }
            FIRDatabase.database().reference().child("users/" + String(describing: user?.uid) + "/cart").setValue(cart)
            //Go to the HomeViewController if the login is sucessful
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "cartViewController")
            self.present(vc!, animated: true, completion: nil)
        } catch (let error) {
            print(error)
        }
    }
    
    @IBAction func photosAddedAndContinue(_ sender: Any) {
        self.generatePDF()
    }
    
    @IBOutlet weak var photosAddedAndContinue: ZFRippleButton!
    @IBAction func AddPhotos(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.imagePickerDelegate = self as! OpalImagePickerControllerDelegate
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var continueButton: ZFRippleButton!
    @IBOutlet weak var addPhotosButton: ZFRippleButton!
    
    func imagePicker(_ picker: Any, didFinishPickingImages images: [UIImage]){
        photos += images
        selectedPhotos.reloadData()
        if photos.count != 0{
            selectedPhotos.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var selectedPhotos: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos.removeAll()
        backgroundImage.layer.cornerRadius = backgroundImage.frame.height/2
        selectedPhotos.isHidden = true
        // Do any additional setup after loading the view.
        imagePicker.navigationBar.tintColor = UIColor.white
        //imagePicker.navigationBar.barStyle = UIBarStyle.black
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        imagePicker.navigationBar.barTintColor = UIColor.black
        //Change status bar style
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
        addPhotosButton.layer.cornerRadius = addPhotosButton.frame.height/2
        continueButton.layer.cornerRadius = continueButton.frame.height/2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectedPhotos.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.userPhotos.image = photos[indexPath.row]
        cell.userPhotos.layer.cornerRadius = 10
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageForEditing = photos[indexPath.row]
        selectedImageNumber = indexPath.row
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
