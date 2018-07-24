//
//  ViewController.swift
//  MusicLibrary
//
//  Created by Afiq Ramli on 20/07/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    private enum Constants {
        static let CellIdentifier = "Cell"
    }
    
    //MARK: - Class properties
    private var currentAlbumIndex = 0
    private var currentAlbumData: [AlbumData]?
    private var allAlbums = [Album]()
    
    //MARK: - UI components
    lazy var albumScrollView: UIView = {
        let view = HorizontalScrollerView()
        view.backgroundColor = .lightGray
        view.delegate = self
        view.dataSource = self
        view.reload()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var albumDetailsTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier)
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bottomToolbar: UIToolbar = {
        let tb = UIToolbar()
        let undoButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        let flexiSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let garbageButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        tb.items = [undoButton, flexiSpace, garbageButton]
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // LibraryAPI singleton init
        allAlbums = LibraryAPI.shared.getAlbums()
        setupNavigationBar()
        setupViews()
        showDataForAlbum(at: currentAlbumIndex)
    }
    
    //MARK: - Helper methods
    
    private func setupNavigationBar() {
        
        let navController = self.navigationController
        navController?.navigationBar.prefersLargeTitles = true
        navController?.navigationItem.largeTitleDisplayMode = .always
        navController?.navigationBar.barTintColor = .white
        navController?.navigationBar.backgroundColor = .white
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)]
        navController?.navigationBar.titleTextAttributes = textAttributes
        navController?.navigationBar.largeTitleTextAttributes = textAttributes
        navController?.navigationBar.isTranslucent = false
        navigationItem.title = "Musics"
        
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = .white
        self.view.addSubview(albumScrollView)
        self.view.addSubview(bottomToolbar)
        self.view.addSubview(albumDetailsTableView)
        
        NSLayoutConstraint.activate([
            albumScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            albumScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            albumScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            albumScrollView.heightAnchor.constraint(equalToConstant: 120)
            ])
        
        NSLayoutConstraint.activate([
            bottomToolbar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomToolbar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomToolbar.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            albumDetailsTableView.topAnchor.constraint(equalTo: albumScrollView.bottomAnchor),
            albumDetailsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            albumDetailsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            albumDetailsTableView.bottomAnchor.constraint(equalTo: bottomToolbar.topAnchor)
            ])
    }
    
    private func showDataForAlbum(at index: Int) {
        
        // defensive code: making sure the requested index is lower than the amount of albums
        if (index < allAlbums.count && index > -1) {
            //fetch the album
            let album = allAlbums[index]
            //save albums data to present it later in the tableView
            currentAlbumData = album.tableRepresentation
        } else {
            currentAlbumData = nil
        }
        // refresh tableview with the data obtained
        albumDetailsTableView.reloadData()
    }
    
}


//MARK: - UITableViewDataSource delegate methods

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albumData = currentAlbumData else { return 0 }
        return albumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set a right-detail UIcollectionview cell type
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Constants.CellIdentifier)
        if let albumData = currentAlbumData {
            let row = indexPath.row
            cell.textLabel!.text = albumData[row].title
            cell.detailTextLabel!.text = albumData[row].value
        }
        return cell
    }
    
}


//MARK: - HorizontalScrollerViewDelegate

extension ViewController: HorizontalScrollerViewDelegate {
    
    
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
        
        // Grab the previously selected album, and deselect the album cover
        let previousAlbumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(false)
        
        // Store current album index
        currentAlbumIndex = index
        
        // Grab the album cover that is currently selected and highlight the selection
        let albumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
        albumView.highlightAlbum(true)
        
        //Display the data for the new album within the tableview
        showDataForAlbum(at: index)
        
    }
    
}

//MARK: - HorizontalScrollerViewDataSource

extension ViewController: HorizontalScrollerViewDataSource {
    
    func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int {
        return allAlbums.count
    }
    
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), coverUrl: album.coverUrl)
        
        if currentAlbumIndex == index {
            albumView.highlightAlbum(true)
        } else {
            albumView.highlightAlbum(false)
        }
        
        return albumView
    }
    
}








