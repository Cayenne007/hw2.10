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
    @IBOutlet var infoPhotoNumber: UILabel!

    var activityView = UIActivityIndicatorView(style: .large)
    
    var backButton = FilterButton(systemName: "arrowtriangle.left")
    var nextButton = FilterButton(systemName: "arrowtriangle.right")
    
    var photos: [RoverPhoto]!
    var photoIndex: Int! {
        didSet {
            if photoIndex < 0 {
                photoIndex = 0
                backButton.pulsate()
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } else if photoIndex > photos.count-1 {
                photoIndex = photos.count-1
                nextButton.pulsate()
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } else if isViewLoaded {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
    
    var photoCountInfo: String {
        "Фото \(photoIndex+1) из \(photos.count)"
    }
    
    var photo: RoverPhoto {
        photos[photoIndex]
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        filterButtonSetConstraint()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
       
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @IBAction func backNextButtonsClick(_ sender: FilterButton) {
        
        activityView.startAnimating()
        photoIndex = ((sender.tag == 0) ? -1 : 1) + photoIndex
        infoLabel.text = photo.description
        infoPhotoNumber.text = photoCountInfo
        NetworkManager.fetchImage(url: photo.imageUrl) { (image) in
            self.imageView.image = image
            self.activityView.stopAnimating()
        }
        
    }
    
    @objc func imageSaved(image:UIImage,didFinishSavingWithError error:Error,contextInfo:UnsafeMutableRawPointer?){
        showAlert(title:"Успешно сохранено", message: "");
    }
    
    
    private func setupViewController() {
        
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.frame = CGRect(x:0,y:0,width:view.frame.width,height:-200)
        activityView.center = view.center
        
        infoLabel.text = photo.description
        infoPhotoNumber.text = photoCountInfo
        infoPhotoNumber.sizeToFit()
        NetworkManager.fetchImage(url: photo.imageUrl) { (image) in
            self.imageView.image = image
            self.activityView.stopAnimating()
        }
        
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backNextButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(backNextButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        nextButton.tag = 1
        
    }
    
    private func filterButtonSetConstraint() {

        let center = -view.frame.size.width / 2 + 25
        
        NSLayoutConstraint.activate([backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: center-100),
                                     backButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     backButton.widthAnchor.constraint(equalToConstant: 50),
                                     backButton.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: center+100),
                                     nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     nextButton.widthAnchor.constraint(equalToConstant: 50),
                                     nextButton.heightAnchor.constraint(equalToConstant: 50)])
        
    }
    
}
