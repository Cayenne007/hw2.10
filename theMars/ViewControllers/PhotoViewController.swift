//
//  PhotoViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!

    var activityView = UIActivityIndicatorView(style: .large)
    
    var backButton = FilterButton(systemName: "arrowtriangle.left")
    var favoriteButton = FavoriteButton(false)
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
 
    var delegate: UpdateFavoriteListDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        filterButtonSetConstraint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = delegate {
            delegate.updateListFavorite()
        }
    }
    
}


//MARK: functions
extension PhotoViewController {
    private func setupViewController() {
        
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.frame = CGRect(x:0,y:0,width:view.frame.width,height:-200)
        activityView.center = view.center
        
        infoLabel.text = photo.description
        titleLabel.text = photoCountInfo

        NetworkManager.shared.fetchImage(photo.imageUrl) { (image) in
            self.imageView.image = image
            self.activityView.stopAnimating()
        }
        
        setFilterButtons()
        
    }
    
}


//MARK: Buttons setup
extension PhotoViewController {
    
    private func setFilterButtons() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backNextButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        
        view.addSubview(favoriteButton)
        favoriteButton.isFavorite = photo.isFavorite
        favoriteButton.addTarget(self, action: #selector(favoriteButtonClick(_:)), for: UIControl.Event.touchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(favoriteButtonLongPress(_:)))
        favoriteButton.addGestureRecognizer(longGesture)
        
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
        
        NSLayoutConstraint.activate([favoriteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: center),
                                     favoriteButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     favoriteButton.widthAnchor.constraint(equalToConstant: 50),
                                     favoriteButton.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: center+100),
                                     nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                     nextButton.widthAnchor.constraint(equalToConstant: 50),
                                     nextButton.heightAnchor.constraint(equalToConstant: 50)])
        
    }
    
    @IBAction func backNextButtonsClick(_ sender: FilterButton) {
        
        activityView.startAnimating()
        photoIndex = ((sender.tag == 0) ? -1 : 1) + photoIndex
        favoriteButton.isFavorite = photo.isFavorite
        infoLabel.text = photo.description
        titleLabel.text = photoCountInfo
        
        NetworkManager.shared.fetchImage(photo.imageUrl) { (image) in
            self.imageView.image = image
            self.activityView.stopAnimating()
        }
        
    }
    
    @IBAction func favoriteButtonClick(_ sender: FavoriteButton) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        sender.isFavorite = !sender.isFavorite
        photo.isFavorite = sender.isFavorite
    }
    
    @IBAction func favoriteButtonLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            guard let image = imageView.image else { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func imageSaved(image:UIImage,didFinishSavingWithError error:Error,contextInfo:UnsafeMutableRawPointer?){
        showAlert(title:"Сохранено в галерею", message: "");
    }
}
