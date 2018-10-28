import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet var downArrow: UIImageView!
    @IBOutlet var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    var trayDownOffset: CGFloat! = nil
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var open : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        open = true
        trayDownOffset = 260
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed {
           trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            if velocity.y > 0 { //up
                UIView.animate(withDuration: 0.300, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
                    self.trayView.center = self.trayDown
                    if self.open {
                        self.downArrow.transform = self.downArrow.transform.rotated(by:(CGFloat(Double.pi)))
                    }
                    self.open = false
                }, completion: nil)
            } else{
                UIView.animate(withDuration: 0.300, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
                    if !self.open {
                        self.downArrow.transform = self.downArrow.transform.rotated(by:(CGFloat(Double.pi)))
                    }
                    self.open = true
                    self.trayView.center = self.trayUp
                }, completion: nil)
            }
    }
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onCopyFacePanRecognizer(sender:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(sender:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(onRotate(sender:)))
        
        if sender.state == .began {
                let imageView = sender.view as! UIImageView
                newlyCreatedFace = UIImageView(image: imageView.image)
                view.addSubview(newlyCreatedFace)
                newlyCreatedFace.center = imageView.center
                newlyCreatedFace.center.y += trayView.frame.origin.y
                newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
                newlyCreatedFace.isUserInteractionEnabled = true
            
                newlyCreatedFace.addGestureRecognizer(panGesture)
                newlyCreatedFace.addGestureRecognizer(pinchGesture)
                newlyCreatedFace.addGestureRecognizer(rotationGesture)
            
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            
        }
        
    }
    

    
    @objc func onRotate(sender: UIRotationGestureRecognizer){
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    @objc func onCopyFacePanRecognizer(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
     
        }
    }
    
    @objc func onPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        sender.scale = 1
    }
    
}

