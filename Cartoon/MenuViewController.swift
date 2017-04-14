//
//  MenuViewController.swift
//  Cartoon
//
//  Created by Maxime Ravau on 26/03/2017.
//  Copyright © 2017 Maxime Ravau. All rights reserved.
//

import UIKit
import GuillotineMenu
import MessageUI
import Social

class MenuViewController: UIViewController, GuillotineMenu, MFMailComposeViewControllerDelegate {

    var titleLabel: UILabel?
    var dismissButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "List2"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTap(_:)), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "MENU"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Menu: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Menu: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Menu: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Menu: viewDidDisappear")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissButtonTap(_ sender: UIButton) {

    presentingViewController!.dismiss(animated: true, completion: nil)
    
    }
    
    
    @IBAction func mailButtonTap(_ sender: UIButton) {
    
        let mailComposeViewController = configuredMailComposeViewController()
        
        if  MFMailComposeViewController.canSendMail(){
            
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        }else{
            
            self.alertMessage()
        }

    
    }
    @IBAction func followTwitter(_ sender: UIButton) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Compte", message: "Veuillez vous connecter à un compte Twitter pour tweeter.",
                                          
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    @IBAction func followFacebook(_ sender: UIButton) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Compte", message: "Veuillez vous connecter à un compte Facebook pour partager.",
                                          
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    @IBAction func followWeibo(_ sender: UIButton) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo) {
            
            let WShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
            
            self.present(WShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Compte", message: "Veuillez vous connecter à un compte Sina Weibo pour partager.",
                                          
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController{
        
        // Fonction qui permet de configurer le mail a envoyer via application.
        
        let mailComposerVC = MFMailComposeViewController()
        
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["Max.ravau@gmail.com"])
        
        mailComposerVC.setSubject("Cartoon")
        
        mailComposerVC.setMessageBody("Partagez nous les problèmes que vous rencontrez sur Cartoon",isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error: Error?) {
        
        dismiss(animated: true, completion: nil) }
    // Fonction mailComposeController qui sert a ce que le boutton envoyer ou annuler soit actif et qui revient a application.
    
    
    
    func alertMessage(){
        
        let alert = UIAlertController(title: "Erreur", message: "Votre appareil n'a pas pu envoyer d'e-mail. Veuillez vérifier la configuration de l'e-mail et réessayer.",
                                      
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func buttonLogOutTap(_ sender: UIButton) {
    
        let alert = UIAlertController(title: "Deconnexion!", message: "Merci de votre Visite, A très Vite!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
    
    
}

extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}

