//
//  ViewControllerHome.swift
//  Cartoon
//
//  Created by Maxime Ravau on 26/03/2017.
//  Copyright © 2017 Maxime Ravau. All rights reserved.
//

import UIKit
import GuillotineMenu
import Parse
import RevealingSplashView

class ViewControllerHome: UIViewController {

    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    var categorieListe = [PFObject]()
    
    var selectedCategorie: PFObject?
    
    
    @IBOutlet var labelPrenom: UILabel!
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = UIColor(red: 174.0 / 255.0, green: 0.0 / 255.0, blue: 3.0 / 255.0, alpha: 1.0)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Animation-100")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:255/255.0, green:83/255.0, blue:82/255.0, alpha:1.0))
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }

        
        
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI(){
        
        getCategorieListe()
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VC: viewWillAppear")
        
        myCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VC: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("VC: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("VC: viewDidDisappear")
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ShowMenuActionButton(_ sender: UIButton) {
    
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender
        present(menuViewController, animated: true, completion: nil)
    
    }
    

        
}

extension ViewControllerHome: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

extension ViewControllerHome: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorieListe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Prototype1", for: indexPath) as! CollectionViewCellHome
        
        cell.imageCover.image = UIImage()
        let categorieObject: PFObject = categorieListe[indexPath.row]
        
        
        if let userPicture = categorieObject["Image"] as? PFFile {
            print("get user picture")
            userPicture.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                print("get user picture response")
                if (error == nil) {
                    print("get user picture no error")
                    cell.imageCover.image = UIImage(data: imageData!)
                    
                    
                }
            })
            
        }
        
        cell.labelTitleCategorie.text = categorieObject["Titre"] as! String?
        
        return cell
    }
    
    func getCategorieListe(){
        
        let query = PFQuery(className:"Categorie")
        query.cachePolicy = PFCachePolicy.cacheThenNetwork
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                print("Successfully retrieved \(objects!.count) scores.")
                self.categorieListe = objects!
                self.myCollectionView.reloadData()
                if let categorieListe = objects {
                    for categorie in categorieListe {
                        let title = categorie["title"]
                        
                        print("\(String(describing: title))")
                        
                    }
                }
            }
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - cellSpacing, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        self.selectedCategorie = categorieListe[indexPath.row]
        
        self.performSegue(withIdentifier: "segue.video", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        
        let nextScene = segue?.destination as! ViewControllerVideo
        
        // je récupère l’index de la cellule sélectionné
        if (segue?.identifier == "segue.video"){
            //je récupère la catégorie a partir de cette index
            
            print("showMovie \(categorieListe)")
            nextScene.currentCategorie = self.selectedCategorie!
            
            // on récupère la segue pour pouvoir ensuite envoyer une nouvelle catégorie sur le button Coming Soon
        }
        
    }


}


