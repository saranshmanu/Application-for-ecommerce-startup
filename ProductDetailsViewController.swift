//
//  ProductDetailsViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 02/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import ImageSlideshow


class ProductDetailsViewController: UIViewController {
    let localSource = [[ImageSource(imageString: "IMG_7604")!, ImageSource(imageString: "IMG_7626")!, ImageSource(imageString: "IMG_7635")!, ImageSource(imageString: "IMG_7652")!]]
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        //buttonTouched(button: addToCartButton)
        cart.append(selectedItemNumber)
    }
    @IBOutlet weak var addToCartButton: ZFRippleButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 2.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.white
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.setImageInputs(localSource[selectedItemNumber])
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailsViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        //addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        cardView.layer.cornerRadius = 0
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


