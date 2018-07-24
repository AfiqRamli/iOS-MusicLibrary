//
//  AlbumView.swift
//  MusicLibrary
//
//  Created by Afiq Ramli on 20/07/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import UIKit

class AlbumView: UIView {
    private var coverImageView: UIImageView!
    private var indicatorView: UIActivityIndicatorView!
    private var valueObservation: NSKeyValueObservation!
    
    // required init methods for every class that subclass this class
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect, coverUrl: String) {
        super.init(frame: frame)
        commonInit()
        
        NotificationCenter.default.post(name: .BLDownloadImage, object: self, userInfo: ["imageView": coverImageView, "coverUrl" : coverUrl])
    }
    
    private func commonInit() {
        // Setup the background
        backgroundColor = .black
        
        // Create the cover image view
        coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coverImageView)
        
        // Create the indicator view
        indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.activityIndicatorViewStyle = .whiteLarge
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        
        valueObservation = coverImageView.observe(\.image, options: [.new]) { [unowned self] observed, change in
            if change.newValue is UIImage {
                self.indicatorView.stopAnimating()
            }
        }
    }
    
    func highlightAlbum(_ didHighlightView: Bool) {
        if didHighlightView == true {
            backgroundColor = .white
        } else {
            backgroundColor = .black
        }
    }
}
