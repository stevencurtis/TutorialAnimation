//
//  ViewController.swift
//  MovingCircleAnimation
//
//  Created by Steven Curtis on 16/01/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    @IBOutlet weak var backgroundImageViewFront: UIImageView!
    @IBOutlet weak var backgroundImageViewBack: UIImageView!
    fileprivate var circleMaskViewBackstop :CircleMaskView?
    fileprivate var circleMaskViewBackground :CircleMaskView?
    
    fileprivate var circleMaskViewForeground:CircleMaskView?


    @IBOutlet var masterView: UIView!
    
    @IBOutlet weak var foregroundColourView: UIView!
    
    @IBOutlet weak var imageClipperBG: UIView!
    @IBOutlet weak var imageClipperFG: UIView!
    @IBOutlet weak var imageClipperBS: UIView!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        print ("test")
    }
    
    fileprivate var pageViewController: UIPageViewController!
    
    //content pages
    fileprivate var pages = [UIViewController]()
    
    // background images
    
    fileprivate var backgroundImages = [
        UIImage(named: "Instruction1"),
        UIImage(named: "Instruction2"),
        UIImage(named: "Instruction3")]
    
    fileprivate var backgroundColours = [UIColor.red, UIColor.blue, UIColor.green, UIColor.clear, UIColor.lightGray]
    
    // text to be displayed on the pages
    fileprivate var carouselPagesTexts = ["Text1",
                                          "Text2",
                                          "Text3"]
    
    //tracking index. This first page displayed defaults to zero
    var currentIndex : Int = 0
    var pendingIndex : Int = 1
    
    fileprivate var tabsPageViewControllerStartIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up pages
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let carouselPage1: InstructionsVC = storyboard.instantiateViewController(withIdentifier: "instructionsVC") as! InstructionsVC
        let carouselPage2: InstructionsVC = storyboard.instantiateViewController(withIdentifier: "instructionsVC") as! InstructionsVC
        let carouselPage3: InstructionsVC = storyboard.instantiateViewController(withIdentifier: "instructionsVC") as! InstructionsVC
        
        pages.append(carouselPage1)
        pages.append(carouselPage2)
        pages.append(carouselPage3)
        
        createPageViewController()
    
        self.backgroundImageViewFront.image = backgroundImages[0]
        
        //set up scrollview delegate for pageview controller
        for subView in pageViewController.view.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delegate = self
            }
        }
    }
    var foregroundFillLayer = CAShapeLayer()
    var backgroundFillLayer = CAShapeLayer()
    var backstopFillLayer = CAShapeLayer()

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(circleMaskViewBackground == nil){
            
            backstopFillLayer.path = UIBezierPath(rect: foregroundColourView.bounds).cgPath
            backstopFillLayer.fillColor = backgroundColours[0].cgColor
            backstopFillLayer.opacity = 1
            foregroundColourView.layer.addSublayer(backstopFillLayer)

            backgroundFillLayer.path = UIBezierPath(rect: foregroundColourView.bounds).cgPath
            backgroundFillLayer.fillColor = backgroundColours[pendingIndex].cgColor
            backgroundFillLayer.opacity = 1
            foregroundColourView.layer.addSublayer(backgroundFillLayer)

            foregroundFillLayer.path = UIBezierPath(rect: foregroundColourView.bounds).cgPath
            foregroundFillLayer.fillColor = backgroundColours[currentIndex].cgColor
            foregroundFillLayer.opacity = 1
            foregroundColourView.layer.addSublayer(foregroundFillLayer)
            
            // backstop
            circleMaskViewBackstop = CircleMaskView(drawIn: imageClipperFG)
            maskViewInCircleMask(circleMask: &circleMaskViewBackstop!, drawIn: imageClipperFG, index: 0, alpha: 1.0)

            circleMaskViewBackground = CircleMaskView(drawIn: imageClipperBG)
            maskViewInCircleMask(circleMask: &circleMaskViewBackground!, drawIn: imageClipperBG, index: pendingIndex, alpha: 1.0)
            
            circleMaskViewForeground = CircleMaskView(drawIn: imageClipperBS)
            maskViewInCircleMask(circleMask: &circleMaskViewForeground!, drawIn: imageClipperBS, index: currentIndex, alpha: 1.0)
        }
    }
    
    func maskViewInCircleMask( circleMask : inout CircleMaskView, drawIn: UIView, index: Int, alpha: CGFloat ) {
        circleMask = CircleMaskView(drawIn: drawIn)
        circleMask.radius = drawIn.frame.size.height * 0.65
        circleMask.fillColor = backgroundColours[index]
        circleMask.fillColor = circleMask.fillColor.withAlphaComponent(alpha)
        circleMask.opacity = 1
        circleMask.draw()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        self.containerView.autoTranslateAnimationWithDistance(8.0, duration: 3)
       //  self.backgroundImageViewFront.autoTranslateAnimationWithDistance(8.0, duration: 3)
    }
    
    
    func createPageViewController() {
        
        // Instantiate the PageViewController
        let pageController = self.storyboard?.instantiateViewController(withIdentifier: "pageVC")
        self.pageViewController = (pageController as! UIPageViewController)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        if backgroundImages.count > 0 {
            let contentController = getContentViewController(withIndex: 0)
            let contentControllers = [contentController]
            
            pageViewController.setViewControllers(
                (contentControllers as! [UIViewController]) , direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
        
        // add to the container (rather than the current view controller), and inform the parent
        self.containerView.addSubview(self.pageViewController.view)
        
        // pin the containerView in code
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        
        self.pageViewController.didMove(toParent: self)
    }
    
    // set up the relevant view controller
    func getContentViewController(withIndex index: Int) -> InstructionsVC? {
        if index < backgroundImages.count {
            if let contentVC = self.storyboard?.instantiateViewController(withIdentifier: "instructionsVC") as? InstructionsVC
            {
                contentVC.image = backgroundImages[index]
                contentVC.index = index
                return contentVC
            }
        }
        return nil
    }

}

extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! InstructionsVC
        let currentIndex = contentVC.index
        if contentVC.index > 0 {
            return getContentViewController(withIndex: currentIndex - 1 )
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! InstructionsVC
        let currentIndex = contentVC.index
        if contentVC.index < backgroundImages.count {
            return getContentViewController(withIndex: currentIndex + 1)
        }
        return nil
    }
    
    // Delegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let nextVC = pendingViewControllers.first! as! InstructionsVC
        pendingIndex = nextVC.index
//        currentIndex = nextVC.index
        
    }
    
    //update pageIndicator
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            
            self.pageIndicator.currentPage = currentIndex
        }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = abs(point.x - view.frame.size.width)/view.frame.size.width

        guard !( pendingIndex == 0 && currentIndex == 0) else {return}
     
        // animation -  transition using alpha
        
        circleMaskViewBackground!.fillColor = backgroundColours[pendingIndex]
        backgroundFillLayer.fillColor = backgroundColours[pendingIndex].cgColor
        
self.backgroundImageViewBack.image = backgroundImages[pendingIndex]
        
        // iconFront.text = iconSet[currentIndex]
        // iconBack.text = iconSet[pendingIndex]
        if (percentComplete <= 0.99) {
            self.backgroundImageViewFront.alpha = 1-percentComplete
            self.backgroundImageViewBack.alpha = percentComplete
            
            backgroundFillLayer.fillColor = UIColor(cgColor: backgroundFillLayer.fillColor!).withAlphaComponent(percentComplete).cgColor
            foregroundFillLayer.fillColor = UIColor(cgColor: foregroundFillLayer.fillColor!).withAlphaComponent(1 - percentComplete).cgColor
            
            circleMaskViewBackground!.fillColor = circleMaskViewBackground!.fillColor.withAlphaComponent(percentComplete)
            circleMaskViewForeground!.fillColor = circleMaskViewForeground!.fillColor.withAlphaComponent(1 - percentComplete)

        } else {
            self.backgroundImageViewFront.image = backgroundImages[pendingIndex]
            self.backgroundImageViewBack.image = backgroundImages[currentIndex]
            
            circleMaskViewForeground!.fillColor = circleMaskViewBackground!.fillColor
            foregroundFillLayer.fillColor = backgroundFillLayer.fillColor
            
            self.backgroundImageViewFront.alpha = percentComplete
            self.backgroundImageViewBack.alpha = 1 - percentComplete
 
//            self.containerView.backgroundColor = backgroundColours[currentIndex]
//            self.masterView.backgroundColor = backgroundColours[currentIndex]
//            iconFront.text = iconSet[pendingIndex]
//            iconBack.text = iconSet[currentIndex]
//            iconFront.alpha = percentComplete
        }
    }
}
