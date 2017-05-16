//
//  DouBanAPI.swift
//  SwiftDemo
//
//  Created by panxinyu on 16/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation
import Alamofire

enum DouBanAPI: API {

    case channels
    case song

    case invalidURL

    var host: String { return "https://api.douban.com/" }

    var header: [String : Any]? { return nil }

    var path: String {
        switch self {
        case .channels:
            return "v2/fm/app_channels"
        case .song:
            return "v2/fm/playlist"
        default:
            return "Invalid path"
        }
    }

    var url: String? {
        switch self {
        case .invalidURL:
            return nil
        default:
            return host + path
        }
    }

    var parameter: [String:Any]? {
        switch self {
        case .channels:
            return [
                "alt": "json",
                "apikey": "02646d3fb69a52ff072d47bf23cef8fd",
                "app_name": "radio_iphone",
                "client": "s:mobile|y:iOS 10.2|f:115|d:b88146214e19b8a8244c9bc0e2789da68955234d|e:iPhone7,1|m:appstore",
                "douban_udid": "b635779c65b816b13b330b68921c0f8edc049590",
                "icon_cate": "xlarge",
                "udid": "b88146214e19b8a8244c9bc0e2789da68955234d",
                "version": "115"
            ]
        case .song:
            return [
                "alt": "json",
                "apikey": "02646d3fb69a52ff072d47bf23cef8fd",
                "app_name": "radio_iphone",
                "channel": "10",
                "client": "s:mobile|y:iOS 10.2|f:115|d:b88146214e19b8a8244c9bc0e2789da68955234d|e:iPhone7,1|m:appstore",
                "douban_udid": "b635779c65b816b13b330b68921c0f8edc049590",
                "formats": "aac",
                "kbps": "128",
                "pt": "0.0",
                "type": "n",
                "udid": "b88146214e19b8a8244c9bc0e2789da68955234d",
                "version": "115"
            ]
        default:
            return nil
        }
    }
}
