//
//  ImageCropperViewController.swift
//  CropPhotoPicker
//
//  Created by Anthony on 24/05/2019.
//  Copyright © 2019 fss. All rights reserved.
//

import UIKit

class ImageCropperViewController: UIViewController, UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var scrollView: FAScrollView!
    let picker = UIImagePickerController()
    private var croppedImage: UIImage? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pinchView(_:)))
//        panGesture.delegate = self
        
        //albumView.addGestureRecognizer(panGesture)
    }

    @IBAction func CropImage(_ sender: Any) {
        croppedImage = captureVisibleRect()
        showImage(image:croppedImage!)
    }
    
    
    @IBAction func rotate(_ sender: UIButton) {
        let getRotateImage = scrollView.imageView.image
        let newImage = getRotateImage?.rotate(radians: .pi/2) // Rotate 90 degrees
        self.scrollView.imageToDisplay = newImage
    }
    
    @IBAction func zoom(_ sender: UIButton) {
        scrollView.zoom()
    }

    private func captureVisibleRect() -> UIImage{
        var croprect = CGRect.zero
        let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
        let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
        
        croprect.origin.x = scrollView.contentOffset.x * xOffset;
        croprect.origin.y = scrollView.contentOffset.y * yOffset;
        
        let normalizedWidth = (scrollView?.frame.width)! / (scrollView?.contentSize.width)!
        let normalizedHeight = (scrollView?.frame.height)! / (scrollView?.contentSize.height)!
        
        croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
        croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
        
        let toCropImage = scrollView.imageView.image?.fixedOrientation()
        let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
        let cropped = UIImage(cgImage: cr!)
        
        return cropped
    }

    func showImage(image:UIImage){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "view") as! ViewController1
        self.present(controller, animated: true, completion: nil)
        controller.photo.image =  croppedImage
    }
    
    @IBAction func album(_ sender: UIButton) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.scrollView.imageToDisplay = chosenImage
        scrollView.imageSize = chosenImage.size
            //scrollView.defaultZoom()
            dismiss(animated:true, completion: nil)
    }
    
    
//    func pinchView(_ pinchGestureRecognizer: UIPinchGestureRecognizer?) {
//        let view: UIView? = pinchGestureRecognizer?.view
//        if pinchGestureRecognizer?.state == .began || pinchGestureRecognizer?.state == .changed {
//            view?.transform = (view?.transform.scaledBy(x: (pinchGestureRecognizer?.scale)!, y: (pinchGestureRecognizer?.scale)!))!
//            pinchGestureRecognizer?.scale = 1
//        }
//        if pinchGestureRecognizer?.state == .ended {
//            let rule = view?.width > view?.height ? view?.width : view?.height
//            let min = CGFloat(ScreenWidth * WIDTHHEIGHTLIMETSCALE)
//            if (rule ?? 0.0) < CGFloat(ScreenWidth) {
//                var width: CGFloat
//                var height: CGFloat
//                if view?.width > view?.height {
//                    width = CGFloat(ScreenWidth)
//                    if let height = view?.height, let width = view?.width {
//                        height = CGFloat(ScreenWidth * height / width)
//                    }
//                } else {
//                    height = CGFloat(ScreenWidth)
//                    if let width = view?.width, let height = view?.height {
//                        width = CGFloat(ScreenWidth * width / height)
//                    }
//                }
//
//                if width < min || height < min {
//                    width = orginSize.width
//                    height = orginSize.height
//                }
//
//                UIView.animate(withDuration: 0.2, animations: {
//                    view?.width = width
//                    view?.height = height
//                    view?.center = CGPoint(x: view?.superview?.width ?? 0.0 / 2.0, y: view?.superview?.height ?? 0.0 / 2.0)
//
//                })
//            } else {
//                var width: CGFloat? = view?.width
//                var height: CGFloat? = view?.height
//                if (width ?? 0.0) > SCALEMAX * orginSize.width || (height ?? 0.0) > SCALEMAX * orginSize.height {
//                    height = SCALEMAX * orginSize.height
//                    width = SCALEMAX * orginSize.width
//                }
//                if (width ?? 0.0) < min || (height ?? 0.0) < min {
//                    width = orginSize.width
//                    height = orginSize.height
//                }
//                let center: CGPoint? = view?.center
//                if (width ?? 0.0) < CGFloat(ScreenWidth) {
//                    center?.x = view?.superview?.width ?? 0.0 / 2.0
//                }
//                if (height ?? 0.0) < CGFloat(ScreenWidth) {
//                    center?.y = view?.superview?.height ?? 0.0 / 2.0
//                }
//
//                UIView.animate(withDuration: 0.2, animations: {
//                    view?.width = width
//                    view?.height = height
//                    view?.center = center ?? CGPoint.zero
//                })
//            }
//
//}
//
//}

}
