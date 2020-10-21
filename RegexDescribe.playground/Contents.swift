import UIKit


extension NSRegularExpression {
    
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> [String] {
        let range = NSRange(location: 0, length: string.utf16.count)
        let results = matches(in: string, options: [], range: range)
        return results.map {
            String(string[Range($0.range, in: string)!]).replacingOccurrences(of: "\"", with: "")
         }
    }
}

let str = "RTSP/1.0 200 OK\r\n\r\nCSeq: 3\r\n\r\nContent-Base: rtsp://172.19.211.59:6754/Streaming\r\n\r\nContent-Type: application/sdp\r\n\r\nContent-Length: 401\r\n\r\n\r\n\r\no=- 213880586 213880586 IN IP4 172.19.211.59\r\n\r\nm=video 0 RTP/AVP 96\r\n\r\nc=IN IP4 0.0.0.0\r\n\r\na=rtpmap:96 H264/90000\r\n\r\na=framerate:0S\r\n\r\na=fmtp:96 profile-level-id=640014; packetization-mode=1; sprop-parameter-sets=Z2QAFK2EAQwgCGEAQwgCGEAQwgCEO1Cw/IA=,aO48sA==\r\n\r\na=control:rtsp://172.19.211.59:6754/Streaming/Video\r\n\r\nm=audio 0 RTP/AVP 8\r\n\r\na=rtpmap:8 PCMA/8000\r\n\r\na=control:rtsp://172.19.211.59:6754/Streaming/Audio"


let regexValoresEntreAspas = NSRegularExpression("a=rtpmap:(.*?)000")
let resultados = regexValoresEntreAspas.matches(str)
print(resultados.last)
