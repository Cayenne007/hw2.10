//
//  PhotoViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    
    var photo: RoverPhoto!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(pictureTap)
        
        infoLabel.text = photo.description
    }
    
    override func viewDidLayoutSubviews() {
        NetworkManager.fetchImageToImageView(url: photo.img_src, imageView: imageView)
    }

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
       
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func imageSaved(image:UIImage,didFinishSavingWithError error:Error,contextInfo:UnsafeMutableRawPointer?){
        self.showAlert(title:"Успешно сохранено", message: "");
    }
    
    
}
