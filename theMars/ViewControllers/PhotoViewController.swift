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
                if Thread.isMainThread {
                    backButton.pulsate()
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
                isAnimating = false
            } else if photoIndex > photos.count-1 {
                photoIndex = photos.count-1
                if Thread.isMainThread {
                    nextButton.pulsate()
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
                isAnimating = false
            } else if !isAnimating && isViewLoaded {
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
    
    var isAnimating = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        NetworkManager.shared.fetchImagesToCache(photos: photos)
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
        NetworkManager.shared.fetchImagesToCache(photos: photos)
    }
    
}


//MARK: Buttons setup
extension PhotoViewController {
    
    private func setFilterButtons() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backNextButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        let longGestureback = UILongPressGestureRecognizer(target: self, action: #selector(backButtonLongPress(_:)))
        backButton.addGestureRecognizer(longGestureback)
        
        view.addSubview(favoriteButton)
        favoriteButton.isFavorite = photo.isFavorite
        favoriteButton.addTarget(self, action: #selector(favoriteButtonClick(_:)), for: UIControl.Event.touchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(favoriteButtonLongPress(_:)))
        favoriteButton.addGestureRecognizer(longGesture)
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(backNextButtonsClick(_:)), for: UIControl.Event.touchUpInside)
        let longGestureNext = UILongPressGestureRecognizer(target: self, action: #selector(nextButtonLongPress(_:)))
        nextButton.addGestureRecognizer(longGestureNext)
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
        
        isAnimating = false
        activityView.startAnimating()
        photoIndex = ((sender.tag == 0) ? -1 : 1) + photoIndex
        changePhoto()
    }
    
    private func changePhoto(_ image: UIImage? = nil) {
        favoriteButton.isFavorite = photo.isFavorite
        infoLabel.text = photo.description
        titleLabel.text = photoCountInfo
        
        if let image = image {
            imageView.image = image
          return
        }
        
        NetworkManager.shared.fetchImage(photo.imageUrl) { (image) in
            self.imageView.image = image
            self.activityView.stopAnimating()
        }
    }
    
    @IBAction func favoriteButtonClick(_ sender: FavoriteButton) {
        isAnimating = false
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        sender.isFavorite = !sender.isFavorite
        photo.isFavorite = sender.isFavorite
    }
    
    @IBAction func favoriteButtonLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        isAnimating = false
        if gesture.state == .began {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            guard let image = imageView.image else { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @IBAction func backButtonLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            animatePhotos(mod: -1)
        } else if gesture.state == .ended {
            isAnimating = false
        }

    }
    
    @IBAction func nextButtonLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            animatePhotos(mod: 1)
        } else if gesture.state == .ended {
            isAnimating = false
        }
    }
    
    @objc func imageSaved(image:UIImage,didFinishSavingWithError error:Error,contextInfo:UnsafeMutableRawPointer?){
        showAlert(title:"Сохранено в галерею", message: "");
    }
    
    
    private func animatePhotos(mod: Int) {
        if isAnimating {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            isAnimating = false
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            isAnimating = true
            
            DispatchQueue.global().async {
                while self.isAnimating {
                    self.photoIndex += mod
                    
                    if let url = URL(string: self.photo.imageUrl) {
                        if let data = DataCache.shared.load(url: url) {
                            let image = UIImage(data: data)
                     
                            DispatchQueue.main.async {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                self.changePhoto(image)
                            }
                        } else {
                            return
                        }
                        
                    }
                    usleep(1_000_000)
                }
            }
        }
    }
    
}
