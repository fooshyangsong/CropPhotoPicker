//
//  FSScrollView.swift
//  CropPhotoPicker
//
//  Created by Anthony on 23/05/2019.
//  Copyright © 2019 fss. All rights reserved.
//

import UIKit
public var fusumaCropImage: Bool  = true

class FAScrollView: UIScrollView{

    // MARK: Class properties
    var imageSize: CGSize?
    var orginSize = CGSize.zero
    var imageView:UIImageView = UIImageView()
    var imageToDisplay:UIImage? = nil{
        didSet{
            zoomScale = 1.0
            minimumZoomScale = 0.8
            imageView.image = imageToDisplay
            //imageView.frame.size = sizeForImageToDisplay()
            let calculatedSize  = sizeForImageToDisplay()
            imageView.frame = CGRect(
                origin: CGPoint.zero,
                size: calculatedSize
            )
            imageView.center = center
            contentSize =   calculatedSize
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            updateLayout()
        }
    }
    
//    var imageToDisplay: UIImage! = nil {
//        didSet {
//            contentMode = .scaleAspectFit
//            if !imageView.isDescendant(of: self) {
//                imageView.alpha = 1.0
//                addSubview(imageView)
//            }
//
//            guard fusumaCropImage else {
//                imageView.frame = frame
//                imageView.contentMode = .scaleAspectFit
//                isUserInteractionEnabled = false
//
//                imageView.image = imageToDisplay
//                return
//            }
//
//            let imageSize = self.imageSize ?? imageToDisplay.size
//            let ratioW = frame.width / imageSize.width // 400 / 1000 => 0.4
//            let ratioH = frame.height / imageSize.height // 300 / 500 => 0.6
//
//            if ratioH > ratioW {
//                imageView.frame = CGRect(
//                    origin: CGPoint.zero,
//                    size: CGSize(width: imageSize.width  * ratioH, height: frame.height)
//                )
//            } else {
//
//                imageView.frame = CGRect(
//                    origin: CGPoint.zero,
//                    size: CGSize(width: frame.width, height: imageSize.height  * ratioW)
//                )
//            }
//
//            contentOffset = CGPoint(
//                x: imageView.center.x - center.x,
//                y: imageView.center.y - center.y
//            )
//
//            //contentSize = CGSize(width: imageView.frame.width + 1, height: imageView.frame.height + 1)
//
//            imageView.image = imageToDisplay
//
//            zoomScale = 1.0
//        }
//    }

    
    
    var gridView:UIView = Bundle.main.loadNibNamed("FAGridView", owner: nil, options: nil)?.first as! UIView
    

    // MARK : Class Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfigurations()
        testsetup()
    }

    func updateLayout() {
        imageView.center = center;
        var frame:CGRect = imageView.frame;
        if (frame.origin.x < 0) { frame.origin.x = 0 }
        if (frame.origin.y < 0) { frame.origin.y = 0 }
        imageView.frame = frame
    }
    
    func zoom() {
        if (zoomScale <= 1.0) { setZoomScale(zoomScaleWithNoWhiteSpaces(), animated: true) }
        else{ setZoomScale(minimumZoomScale, animated: true) }
        updateLayout()
    }
    
    func defaultZoom(){
        setZoomScale(zoomScaleWithNoWhiteSpaces(), animated: false)
        updateLayout()
    }
    
    // MARK: Private Functions
    
    private func viewConfigurations(){
        
//        clipsToBounds = false;
//        showsVerticalScrollIndicator = false
//        showsHorizontalScrollIndicator = false
//        alwaysBounceHorizontal = true
//        alwaysBounceVertical = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
        addSubview(imageView)
        
        gridView.frame = frame
        gridView.isHidden = true
        gridView.isUserInteractionEnabled = false
        addSubview(gridView)
    }
    
    private func sizeForImageToDisplay() -> CGSize{
        
        var actualWidth:CGFloat = imageToDisplay!.size.width
        var actualHeight:CGFloat = imageToDisplay!.size.height
        var imgRatio:CGFloat = actualWidth/actualHeight
        let maxRatio:CGFloat = frame.size.width/frame.size.height
        
        
        if imgRatio != maxRatio{
            if(imgRatio < maxRatio){
                let imageSize =  imageToDisplay!.size
                let ratioW = frame.width / imageSize.width // 400 / 1000 => 0.4
                let ratioH = frame.height / imageSize.height // 300 / 500 => 0.6
                
                imgRatio = frame.size.height / actualHeight
                actualWidth = frame.width
                actualHeight =  (imageToDisplay?.size.height ?? 0) * ratioW
                
//                if ratioW > (ratioH*2) {
//                    //Strange Behavior Image
//                    imgRatio = frame.size.height / actualHeight
//                    actualWidth =  imageSize.width  * ratioH
//                    actualHeight =  (imageToDisplay?.size.height ?? 0) * ratioW
//                } else {
//                    //Standard Potrait Image
//                    imgRatio = frame.size.height / actualHeight
//                    actualWidth = frame.width
//                    actualHeight =  (imageToDisplay?.size.height ?? 0) * ratioW
//                }
            } else{
                //Horizontal Image
                imgRatio = frame.size.width / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = frame.size.width
            }
        }
        else {
            imgRatio = frame.size.width / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = frame.size.width
        }
        
        orginSize = self.imageView.frame.size

        return  CGSize(width: actualWidth, height: actualHeight)
    }
    
    private func zoomScaleWithNoWhiteSpaces() -> CGFloat{
        
        let imageViewSize:CGSize  = imageView.bounds.size
        let scrollViewSize:CGSize = bounds.size;
        let widthScale:CGFloat  = scrollViewSize.width / imageViewSize.width
        let heightScale:CGFloat = scrollViewSize.height / imageViewSize.height
        return max(widthScale, heightScale)
    }
    
    func testsetup(){
        backgroundColor = UIColor.darkGray
        frame.size      = CGSize.zero
        clipsToBounds   = true
        
        imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        
        maximumZoomScale = 2.0
        minimumZoomScale = 0.8
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator   = false
        bouncesZoom = true
        bounces = true
        scrollsToTop = false
    }

}



extension FAScrollView:UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame

        updateLayout()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        gridView.isHidden = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        gridView.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        var frame:CGRect = gridView.frame;
        frame.origin.x = scrollView.contentOffset.x
        frame.origin.y = scrollView.contentOffset.y
        gridView.frame = frame
        
        switch scrollView.pinchGestureRecognizer!.state {
        case .changed:
            gridView.isHidden = false
            break
        case .ended:
            gridView.isHidden = true
            break
        default: break
        }
        
    }
    
}
