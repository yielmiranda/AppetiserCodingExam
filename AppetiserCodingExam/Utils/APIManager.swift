//
//  APIManager.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import RxSwift
import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class APIManager: NSObject {
    
    //MARK: - Properties
    
    static var shared: APIManager!
    static var baseURL: URL!
    
    private var sessionManager: SessionManager
    private var imageCache: AutoPurgingImageCache!
    
    private var disposeBag = DisposeBag()
    
    //MARK: - Methods
    
    init(baseUrl: String) {
        APIManager.baseURL = URL(string: baseUrl)
         
        let configuration = URLSessionConfiguration.default
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
        
        super.init()
            
        APIManager.shared = self
    }
    
    /**
     Main handler of all api requests
     
     - Parameter request: an object containing details of the web service request
     - Returns: an Observable of element JSON
     */
    @discardableResult
    func perform(request: Request) -> Observable<JSON> {
        return Observable.create({ observer -> Disposable in
            let urlRequest = request.getRequest()
            
            self.sessionManager.request(urlRequest).responseJSON(completionHandler: { response in
                if let error = response.error {
                    observer.onError(APIClientError.RequestError(error))
                } else {
                    guard let _ = response.response else {
                        observer.onError(APIClientError.CouldNotDecodeJSON)
                        return
                    }
                    
                    do {
                        let json = try JSON(data: response.data ?? Data(),
                                            options: JSONSerialization.ReadingOptions.allowFragments)
                        print(json)
                        observer.onNext(json)
                        observer.onCompleted()
                    } catch {
                        observer.onError(APIClientError.CouldNotDecodeJSON)
                    }
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     For downloading and caching of images
     
     - Parameter request: an object containing details of the web service request
     - Returns: an Observable of element Image
     */
    func performDownloadImageRequest(request: Request) -> Observable<Image> {
        return Observable.create({ observer -> Disposable in
            var urlRequest = URLRequest(url: URL(string: request.path)!)
            urlRequest.httpMethod = request.method.rawValue
            
            self.sessionManager.request(urlRequest).responseImage(completionHandler: { response in
                if let error = response.error {
                    observer.onError(APIClientError.RequestError(error))
                } else {
                    guard let _ = response.response else {
                        observer.onError(APIClientError.CouldNotRetrieveImage)
                        return
                    }
                    
                    guard let image = response.result.value else {
                        observer.onError(APIClientError.CouldNotRetrieveImage)
                        return
                    }
                    
                    //save to cache first
                    let imageCacheKey = request.path
                    self.imageCache.add(image, withIdentifier: imageCacheKey)
                    
                    observer.onNext(image)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }

    /**
     For checking and loading of image from cache
     
     - Parameter imageUrl: url string which serves as the identifier from cache
     - Returns: an Image if it exists, nil if not
     */
    func loadImageFromCache(imageUrl: String) -> UIImage? {
        if let image = self.imageCache.image(withIdentifier: imageUrl) {
            return image
        }
        
        return nil
    }
}
