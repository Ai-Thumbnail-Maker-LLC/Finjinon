//
//  Copyright (c) 2017 FINN.no AS. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import YPImagePicker

public protocol ImagePickerAdapter {
    // Return a UIViewController suitable for picking one or more images. The supplied selectionHandler may be called more than once.
    // the argument is a dictionary with either (or both) the UIImagePickerControllerOriginalImage or UIImagePickerControllerReferenceURL keys
    // The completion handler will be called when done, supplying the caller with a didCancel flag which will be true
    // if the user cancelled the image selection process.
    // NOTE: The caller is responsible for dismissing any presented view controllers in the completion handler.
    func viewControllerForImageSelection(_ selectedAssetsHandler: @escaping ([PHAsset]) -> Void, completion: @escaping (Bool) -> Void) -> UIViewController
}

open class ImagePickerControllerAdapter: NSObject, ImagePickerAdapter, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectionHandler: ([PHAsset]) -> Void = { _ in }
    var completionHandler: (_ didCancel: Bool) -> Void = { _ in }

    open func viewControllerForImageSelection(_ selectedAssetsHandler: @escaping ([PHAsset]) -> Void, completion: @escaping (Bool) -> Void) -> UIViewController {
        selectionHandler = selectedAssetsHandler
        completionHandler = completion

        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 20
        config.library.minNumberOfItems = 1
        config.showsPhotoFilters = false
        config.library.defaultMultipleSelection = true
        //config.wordings.
        config.screens = [.library]

        // [Edit configuration here ...]
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [self, unowned picker] items, _ in
//            if let photo = items.singlePhoto {
//                print(photo.fromCamera) // Image source (camera or library)
//                print(photo.image) // Final image selected by the user
//                print(photo.originalImage) // original image selected by the user, unfiltered
//                print(photo.modifiedImage) // Transformed image, can be nil
//                print(photo.exifMeta) // Print exif meta data of original image.
//            }
            var assets : [PHAsset] = []
            
            for i in items {
                
                switch i {
                        case .photo(let photo):
                    
                    assets.append(photo.asset!)
                case .video(let video): break
                    
                }
               
            }
            
//            guard let referenceURL = info[.referenceURL] as? URL else {
//                completionHandler(true)
//                return
//            }

            selectionHandler(assets)
            //completionHandler(false)
//            let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
//            if let asset = fetchResult.firstObject {
//                selectionHandler([asset])
//                completionHandler(false)
//            } else {
//                NSLog("*** Failed to fetch PHAsset for asset library URL: \(referenceURL): \(String(describing: fetchResult.firstObject))")
//                completionHandler(true)
//            }
            
            
            picker.dismiss(animated: true, completion: nil)
        }
        return picker
//        let picker = UIImagePickerController()
//        picker.mediaTypes = [kUTTypeImage as String]
//        picker.delegate = self
//
//        return picker
    }

    open func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let referenceURL = info[.referenceURL] as? URL else {
            completionHandler(true)
            return
        }

        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
        if let asset = fetchResult.firstObject {
            selectionHandler([asset])
            completionHandler(false)
        } else {
            NSLog("*** Failed to fetch PHAsset for asset library URL: \(referenceURL): \(String(describing: fetchResult.firstObject))")
            completionHandler(true)
        }
    }

    open func imagePickerControllerDidCancel(_: UIImagePickerController) {
        completionHandler(true)
    }
}
