//
//  PhotosSelectionViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 22/08/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import OpalImagePicker

class PhotosSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, OpalImagePickerControllerDelegate {
    
    var photos = [UIImage]()
    let imagePicker = OpalImagePickerController()

    
    @IBAction func photosAddedAndContinue(_ sender: Any) {
        
    }
    @IBOutlet weak var photosAddedAndContinue: ZFRippleButton!
    @IBAction func AddPhotos(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.imagePickerDelegate = self as! OpalImagePickerControllerDelegate
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
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
        // Do any additional setup after loading the view.
        selectedPhotos.isHidden = true
        imagePicker.navigationBar.tintColor = UIColor.white
        //imagePicker.navigationBar.barStyle = UIBarStyle.black
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        imagePicker.navigationBar.barTintColor = UIColor.black
        //Change status bar style
        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
