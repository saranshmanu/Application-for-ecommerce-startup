//
//  ProductDetailsViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 02/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import ImageSlideshow
import ImagePicker
import Lightbox

class ProductDetailsViewController: UIViewController, ImagePickerDelegate {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        buttonTouched(button: addToCartButton)
        cart.append(selectedItemNumber)
    }
    @IBOutlet weak var addToCartButton: ZFRippleButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var cardView: UIView!
    
    let localSource = [ImageSource(imageString: "One")!, ImageSource(imageString: "Two")!, ImageSource(imageString: "Three")!, ImageSource(imageString: "Four")!]
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.white
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.setImageInputs(localSource)
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailsViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        cardView.layer.cornerRadius = 10
        slideshow.layer.cornerRadius = 10
        
        productLabel.text = productName[selectedItemNumber]
        productDescription.text = productDescriptionOfTheItem[selectedItemNumber]
        productPrice.text = productPriceOfTheItem[selectedItemNumber]
    }
    func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func makeButton() -> UIButton {
//        let button = UIButton()
//        button.setTitle("Show ImagePicker", for: .normal)
//        button.setTitleColor(UIColor.black, for: .normal)
//        button.addTarget(self, action: #selector(buttonTouched(button:)), for: .touchUpInside)
//        return button
//    }
    
    func buttonTouched(button: UIButton) {
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        let imagePicker = ImagePickerController()
        imagePicker.configuration = config
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - ImagePickerDelegate
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Done button pressed")
        print(images)
        imagePicker.dismiss(animated: true, completion: nil)
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
