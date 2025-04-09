//
//  ImageCacheManager.swift
//  Talent
//
//  Created by Ihab yasser on 05/08/2023.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default

    private init() {
        memoryCache.totalCostLimit = 100 * 1024 * 1024 // Set a 100MB memory cache limit (adjust as needed)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        let cost = image.pngData()?.count ?? 0
        memoryCache.setObject(image, forKey: key as NSString, cost: cost)
        saveImageToDisk(image, forKey: key)
    }

    func image(forKey key: String) -> UIImage? {
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        }
        return loadImageFromDisk(forKey: key)
    }
    
    func imageFromMemory(forKey key: String) -> UIImage?{
        return memoryCache.object(forKey: key as NSString)
    }

    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
        DispatchQueue.global(qos: .background).async {
            if let data = image.pngData() {
                let cachePath = self.getCacheFilePath(forKey: key)
                self.fileManager.createFile(atPath: cachePath.path, contents: data, attributes: nil)
            }
        }
    }

    private func loadImageFromDisk(forKey key: String) -> UIImage? {
        let cachePath = getCacheFilePath(forKey: key)
        if let imageData = fileManager.contents(atPath: cachePath.path) {
            return UIImage(data: imageData)
        }
        return nil
    }

    private func getCacheFilePath(forKey key: String) -> URL {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileName = key.replacingOccurrences(of: "/", with: "_")
        return cacheDirectory.appendingPathComponent(fileName)
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        DispatchQueue.global(qos: .background).async {
            let cacheDirectory = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            do {
                let fileURLs = try self.fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: [])
                for fileURL in fileURLs {
                    try self.fileManager.removeItem(at: fileURL)
                }
            } catch {
                print("Error clearing cache: \(error)")
            }
        }
    }
}
