
import Foundation
extension String {
    
    var lastPathComponent: String { (self as NSString).lastPathComponent }
    
    var pathExtension: String { (self as NSString).pathExtension }
      
    var stringByDeletingLastPathComponent: String { (self as NSString).deletingLastPathComponent }
     
    var deletePathExtension: String { (self as NSString).deletingPathExtension }
    
    var pathComponents: [String] { (self as NSString).pathComponents }
    
    func appendPathComponent(_ path: String) -> String { (self as NSString).appendingPathComponent(path) }
     
    func stringByAppendingPathExtension(_ ext: String) -> String? { (self as NSString).appendingPathExtension(ext) }
    
}
