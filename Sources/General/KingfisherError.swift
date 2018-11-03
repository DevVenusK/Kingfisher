//
//  KingfisherError.swift
//  Kingfisher
//
//  Created by onevcat on 2018/09/26.
//
//  Copyright (c) 2018 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/// Error domain of Kingfisher
public let KingfisherErrorDomain = "com.onevcat.Kingfisher.Error"

extension Never: Error {}

public enum KingfisherError: Error {
    
    public enum RequestErrorReason {
        case emptyRequest
        case invalidURL(request: URLRequest)
        case taskCancelled(task: SessionDataTask, token: SessionDataTask.CancelToken?)
    }
    
    public enum ResponseErrorReason {
        case invalidURLResponse(response: URLResponse)
        case invalidHTTPStatusCode(response: HTTPURLResponse)
        case URLSessionError(error: Error)
        case dataModifyingFailed(task: SessionDataTask)
        case noURLResponse
    }
    
    public enum CacheErrorReason {
        case fileEnumeratorCreationFailed(url: URL)
        case invalidFileEnumeratorContent(url: URL)
        case invalidURLResource(error: Error, key: String, url: URL, resourceKeys: Set<URLResourceKey>)
        case invalidModificationDate(key: String, url: URL)
        case cannotCreateDirectory(error: Error, path: String)
        case imageNotExisting(key: String)
        case cannotConvertToData(object: Any, error: Error)
        case cannotSerializeImage(image: Image, original: Data?, serializer: CacheSerializer)
    }
    
    public enum ProcessorErrorReason {
        case processingFailed(processor: ImageProcessor, item: ImageProcessItem)
    }

    public enum ImageSettingErrorReason {
        case emptyResource
        case notCurrentResource(result: RetrieveImageResult?, error: Error?, resource: Resource)
    }
    
    case requestError(reason: RequestErrorReason)
    case responseError(reason: ResponseErrorReason)
    case cacheError(reason: CacheErrorReason)
    case processorError(reason: ProcessorErrorReason)
    case imageSettingError(reason: ImageSettingErrorReason)
    
    var isTaskCancelled: Bool {
        if case .requestError(reason: .taskCancelled) = self {
            return true
        }
        return false
    }

    func isInvalidResponseStatusCode(_ code: Int) -> Bool {
        if case .responseError(reason: .invalidHTTPStatusCode(let response)) = self {
            return response.statusCode == code
        }
        return false
    }
}

/// Key will be used in the `userInfo` of `.invalidStatusCode`
public let KingfisherErrorStatusCodeKey = "statusCode"
