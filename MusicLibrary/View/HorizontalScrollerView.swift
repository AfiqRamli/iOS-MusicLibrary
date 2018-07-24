//
//  HorizontalScrollerView.swift
//  MusicLibrary
//
//  Created by Afiq Ramli on 21/07/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import UIKit

protocol HorizontalScrollerViewDataSource: class {
    // Ask the data source how many views it wants to present inside the horizontal scroller
    func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int
    
    // Ask the data source to return the view that should appear at <index>
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView
}

protocol HorizontalScrollerViewDelegate: class {
    // inform the delegate that the view at <index> has been selected
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int)
}

class HorizontalScrollerView: UIView {
    
    weak var dataSource: HorizontalScrollerViewDataSource?
    weak var delegate: HorizontalScrollerViewDelegate?
    
    private enum ViewConstants {
        static let Padding: CGFloat = 10
        static let Dimensions: CGFloat = 100
        static let Offset: CGFloat = 100
    }
    private let scroller = UIScrollView()
    private var contentViews = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeScrollView() {
        scroller.delegate = self
        
        // 1
        self.addSubview(scroller)
        scroller.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scroller.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scroller.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scroller.topAnchor.constraint(equalTo: self.topAnchor),
            scroller.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        //2
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollerTapped(gesture:)))
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    func scrollToView(at index: Int, animated: Bool = true) {
        let centralView = contentViews[index]
        let targetCenter = centralView.center
        let targetOffsetX = targetCenter.x - (scroller.bounds.width)
        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
    }
    
    @objc func scrollerTapped(gesture: UITapGestureRecognizer) {
        
        let location = gesture.location(in: scroller)
        guard let index = contentViews.index(where: { $0.frame.contains(location) }) else { return }
        
        delegate?.horizontalScrollerView(self, didSelectViewAt: index)
        scrollToView(at: index)
        
    }
    
    func view(at index: Int) -> UIView {
        return contentViews[index]
    }
    
    // The following code to reload the scroller (mimics the reloadData() method from tableView)
    
    func reload() {
        // Check for data source existence, if not theres nothing to load
        guard let dataSource = dataSource else { return }
        
        // Remove the old content views
        contentViews.forEach { $0.removeFromSuperview() }
        
        // xValue is the starting point of each view inside the scroller
        var xValue = ViewConstants.Offset
        
        // Fetch and add the new views
        contentViews = (0..<dataSource.numberOfViews(in: self)).map{
            index in
            // add a view at the right position
            xValue += ViewConstants.Padding
            let view = dataSource.horizontalScrollerView(self, viewAt: index)
            view.frame = CGRect(x: CGFloat(xValue), y: ViewConstants.Padding, width: ViewConstants.Dimensions, height: ViewConstants.Dimensions)
            scroller.addSubview(view)
            xValue += ViewConstants.Dimensions + ViewConstants.Padding
            return view
        }
        scroller.contentSize = CGSize(width: CGFloat(xValue + ViewConstants.Offset), height: self.frame.size.height)
    }
    
    private func centerCurrentView() {
        
        let centerRect = CGRect(origin: CGPoint(x: scroller.bounds.midX - ViewConstants.Padding, y: 0), size: CGSize(width: ViewConstants.Padding, height: bounds.height))
        
        guard let selectedIndex = contentViews.index(where: { $0.frame.intersects(centerRect) })
            else { return }
        let centralView = contentViews[selectedIndex]
        let targetCenter = centralView.center
        let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)
        
        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
        delegate?.horizontalScrollerView(self, didSelectViewAt: selectedIndex)
    }
    
}


extension HorizontalScrollerView: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCurrentView()
    }
    
}























