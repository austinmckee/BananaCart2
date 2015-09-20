import UIKit
import AVFoundation


class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var camTransform    : CGAffineTransform = CGAffineTransformIdentity
    var myMaster : MasterViewController?
    
    func newMaster(newMaster: MasterViewController) {
        myMaster = newMaster
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin.union(UIViewAutoresizing.FlexibleBottomMargin.union(UIViewAutoresizing.FlexibleLeftMargin.union(UIViewAutoresizing.FlexibleRightMargin)))
        
        // Set the transform of the camera view
        //camTransform = CGAffineTransformScale(camTransform, 1.0, -1.0)
        camTransform = CGAffineTransformRotate(camTransform, CGFloat(M_PI_2 * 3.0))
        
        /*|
        UIViewAutoresizing.FlexibleBottomMargin.rawValue |
        UIViewAutoresizing.FlexibleLeftMargin.rawValue |
        UIViewAutoresizing.FlexibleRightMargin.rawValue*/
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        // All cameras
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // For getting the front camera
        /*
        for dev in videoDevices {
            let dev = dev as! AVCaptureDevice
            if dev.position == AVCaptureDevicePosition.Front {
                device = dev
                break
            }
        }*/
        
        
        // For the sake of discussion this is the camera
        //let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //let device = AVCaptureDevice.
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        
        do {
            let input : AVCaptureDeviceInput? = try AVCaptureDeviceInput.init(device: device) as AVCaptureDeviceInput
            session.addInput(input)
        } catch {
            print("Could not activate camera");
        }
        
        
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session) as AVCaptureVideoPreviewLayer
       
         previewLayer.frame = self.view.bounds
        
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        previewLayer.setAffineTransform(camTransform)
        self.view.layer.addSublayer(previewLayer)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    //self.session.stopRunning()
                    break
                }
                
            }
        }
        
        if detectionString == nil {
            print("nil detect string")
        } else {
            if myMaster != nil {
                myMaster!.recognized(detectionString)
            } else {
                print("no master set!")
            }
            print(detectionString)
        }
        
        self.highlightView.frame = highlightViewRect
        self.highlightView.transform = CGAffineTransformTranslate(camTransform, -50, 30);
        self.view.bringSubviewToFront(self.highlightView)
        
    }
    
    
}