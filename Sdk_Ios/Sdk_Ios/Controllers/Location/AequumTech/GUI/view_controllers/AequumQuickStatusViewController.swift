//
//  AequumQuickStatusViewController.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-11-13.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit

class AequumQuickStatusViewController: UIViewController {
    
    // 378 x 573
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var aeStatusView: UIView!
    @IBOutlet var pagingIndicator: UIPageControl!
    
    var slide0: Slide0ViewController!
    var slide1: Slide1ViewController!
    var slide2: Slide2ViewController!
    var slide3: Slide3ViewController!
    var slide4: Slide4ViewController!
    var slide5: Slide5ViewController!
    var slide6: Slide6ViewController!

    var slides: [UIView] = [UIView]()
    
    @IBAction func closeAqeuumStatusScreen(_ sender: Any) {
        
        self.dismiss(animated: true, completion:  {
                print("do something here.")
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        aeStatusView.layer.cornerRadius = 10.0
        aeStatusView.layer.masksToBounds = true
        createSlides()
        pagingIndicator.numberOfPages = slides.count
        
        // Do any additional setup after loading the view.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSlideScrollView(slides: slides)

    }
    
    func setupSlideScrollView(slides : [UIView]) {

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i])
        }
        
        scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
        pagingIndicator.currentPage = 1
        
    }

    
    func createSlides() {

        slide0 = Slide0ViewController(nibName: "Slide0ViewController", bundle: Bundle(for: Slide0ViewController.self)) as Slide0ViewController
        slide1 = Slide1ViewController(nibName: "Slide1ViewController", bundle: Bundle(for: Slide1ViewController.self)) as Slide1ViewController
        slide2 = Slide2ViewController(nibName: "Slide2ViewController", bundle: Bundle(for: Slide2ViewController.self)) as Slide2ViewController
        slide3 = Slide3ViewController(nibName: "Slide3ViewController", bundle: Bundle(for: Slide3ViewController.self)) as Slide3ViewController
        slide4 = Slide4ViewController(nibName: "Slide4ViewController", bundle: Bundle(for: Slide4ViewController.self)) as Slide4ViewController
        slide5 = Slide5ViewController(nibName: "Slide5ViewController", bundle: Bundle(for: Slide5ViewController.self)) as Slide5ViewController
        slide6 = Slide6ViewController(nibName: "Slide6ViewController", bundle: Bundle(for: Slide6ViewController.self)) as Slide6ViewController

        slides.append(slide0.view)
        slides.append(slide1.view)
        slides.append(slide2.view)
        slides.append(slide3.view)
        slides.append(slide4.view)
        slides.append(slide5.view)
        slides.append(slide6.view)

    }
}

extension AequumQuickStatusViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == 0 {
            self.pagingIndicator.currentPage = Int(0)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        let thisPageIs = Int(currentPage)
        self.pagingIndicator.currentPage = thisPageIs;
        
    }

}
