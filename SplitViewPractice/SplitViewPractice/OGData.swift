//
//  OGData.swift
//  SplitViewPractice
//
//  Created by 임성훈 on 02/12/2018.
//  Copyright © 2018 임성훈. All rights reserved.
//

import Foundation
import Kanna

struct OGData {
    let title: String?
    let description: String?
    let url: URL?
    let imageURL: URL?
    
    static func ogData(from targetUrl: URL) -> OGData? {
        guard let doc = try? HTML(url: targetUrl as URL, encoding: .utf8) else {
            return nil
        }
        
        let title = doc.xpath("//meta[@property='og:title']").first?["content"]
        let description = doc.xpath("//meta[@property='og:description']").first?["content"]
        let imageURLString = doc.xpath("//meta[@property='og:image']").first?["content"]
        let urlString = doc.xpath("//meta[@property='og:url']").first?["content"]
        let imageURL = URL(string: imageURLString ?? "")?.standardized.appendHTTPPrefix()
        let siteUrl = URL(string: urlString ?? "")?.standardized.appendHTTPPrefix()
        
        return OGData(title: title,
                      description: description,
                      url: siteUrl,
                      imageURL: imageURL)
    }
}

extension URL {
    func appendHTTPPrefix() -> URL? {
        if self.absoluteString.hasPrefix("http://") || self.absoluteString.hasPrefix("https://") {
            return self
        } else {
            return URL(string: String(format: "http://%@", self.absoluteString))
        }
    }
}
