//
//  ViewController.swift
//  ParallaxEffect
//
//  Created by ViViViViViVi on 2016/8/6.
//  Copyright © 2016年 Lanaya_HSIEH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let fakeArray = (0..<20).map { i in
        return "This is \(i+1) cell."
    }
    
    var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.allowsSelection = false
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = UIImage(named: "girl_image")
        }
    }
    
    let imageHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        imageView = UIImageView(frame: CGRect(x: 0, y: -150, width: view.bounds.width, height: imageHeight))
        imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        view.addSubview(imageView)
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIView.beginAnimations(nil, context: nil)
        makeParallaxEffect()
        UIView.commitAnimations()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.beginAnimations(nil, context: nil)
        navigationController?.navigationBar.alpha = 1.0
        UIView.commitAnimations()
    }

    func makeParallaxEffect() {
        let point = tableView.contentOffset
        
        if point.y < -imageHeight {
            let scaleFactor = fabs(point.y) / imageHeight
            imageView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        } else {
            imageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
        
        if point.y <= 0 {
            if point.y >= -imageHeight {
                imageView.transform = CGAffineTransformTranslate(imageView.transform, 0, (fabs(point.y)-imageHeight)/2.0)
            }
            
            imageView.alpha = fabs(point.y/imageHeight)
            navigationController?.navigationBar.alpha = 1 - CGFloat(powf(Float(fabs(point.y/imageHeight)), 3))
        } else {
            imageView.transform = CGAffineTransformTranslate(imageView.transform, 0, 0)
            imageView.alpha = 0
            navigationController?.navigationBar.alpha = 1.0
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        makeParallaxEffect()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        cell.textLabel?.text = fakeArray[indexPath.row]
        
        return cell
    }
}