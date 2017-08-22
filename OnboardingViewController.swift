//
//  OnboardingViewController.swift
//  Startup
//
//  Created by Saransh Mittal on 03/07/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
//import paper_onboarding

class OnboardingViewController: UIViewController {

    @IBOutlet weak var DoneButton: UIButton!
//    @IBOutlet var onboarding: PaperOnboarding!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DoneButton.isHidden = true
//        onboarding.dataSource = self
//        onboarding.delegate = self
        DoneButton.layer.cornerRadius = 15
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func DoneAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "TermsAccepted")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(vc!, animated: true, completion: nil)
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

//extension OnboardingViewController: PaperOnboardingDelegate {
//    func onboardingWillTransitonToIndex(_ index: Int) {
//        if index == 2{
//            DoneButton.isHidden = false
//        }
//        else{
//            DoneButton.isHidden = true
//        }
//    }
//    func onboardingDidTransitonToIndex(_ index: Int) {
//    }
//    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
//        //    item.titleLabel?.backgroundColor = .redColor()
//        //    item.descriptionLabel?.backgroundColor = .redColor()
//        //    item.imageView = ...
//    }
//}
//extension OnboardingViewController: PaperOnboardingDataSource {
//
//    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
//        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
//        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
//        return [
//            ("One", "Welcome", "NASA Space Apps Challenge 2017", "One", UIColor.init(red: 12/255, green: 21/255, blue: 26/255, alpha: 1.0), UIColor.white, UIColor.white, titleFont,descriptionFont),
//            ("One", "VIT University", "Vellore", "One", UIColor.init(red: 0/255, green: 157/255, blue: 214/255, alpha: 1.0), UIColor.white, UIColor.white, titleFont,descriptionFont),
//            ("One", "Are you ready?", "Lets get started", "One", UIColor.black, UIColor.white, UIColor.white, titleFont,descriptionFont)
//            ][index]
//    }
//
//    func onboardingItemsCount() -> Int {
//        return 3
//    }
//}

