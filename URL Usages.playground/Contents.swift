import UIKit

if let url = URL(string: "rtsp://admin:admin@177.129.4.51:6754/Streaming"){
    
    print("URL absoluteString:", url.absoluteString)
    print("URL absoluteURL:", url.absoluteURL)
    print("URL baseURL:", url.baseURL as Any)
    print("URL fragment:", url.fragment ?? "")
    print("URL host:", url.host ?? "")
    print("URL lastPathComponent:", url.lastPathComponent)
    print("URL path:", url.path)
    print("URL pathComponents:", url.pathComponents)
    print("URL pathExtension:", url.pathExtension)
    print("URL port:", url.port ?? 0)
    print("URL query:", url.query ?? "")
    print("URL relativePath:", url.relativePath)
    print("URL relativeString:", url.relativeString)
    print("URL scheme:", url.scheme ?? "")
    print("URL standardized:", url.standardized)
    print("URL standardizedFileURL:", url.standardizedFileURL)
    print("URL user:", url.user ?? "")
    print("URL password:", url.password ?? "")
}else {
    print("URL INVALIDA")
}




