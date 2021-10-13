
import Foundation


public struct InfoPlist: Codable {
    
    enum CodingKeys: String, CodingKey {
        case bundleName                   = "CFBundleName"
        case bundleVersionShort           = "CFBundleShortVersionString"
        case bundleVersion                = "CFBundleVersion"
        case bundleIdentifier             = "CFBundleIdentifier"
        case minOSVersion                 = "MinimumOSVersion"
        case bundleIcons                  = "CFBundleIcons"
        case bundleIconFile               = "CFBundleIconFile"
        case bundleIconFiles              = "CFBundleIconFiles"
        case xcodeVersion                 = "DTXcode"
        case xcodeBuild                   = "DTXcodeBuild"
        case sdkName                      = "DTSDKName"
        case buildSDK                     = "DTSDKBuild"
        case buildMachineOSBuild          = "BuildMachineOSBuild"
        case platformVersion              = "DTPlatformVersion"
        case supportedPlatforms           = "CFBundleSupportedPlatforms"
        case bundleExecutable             = "CFBundleExecutable"
        case bundleResourceSpecification  = "CFBundleResourceSpecification"
        case companionAppBundleIdentifier = "WKCompanionAppBundleIdentifier"
    }
    
    public var bundleName:                     String
    public var bundleVersionShort:             String
    public var bundleVersion:                  String
    public var bundleIdentifier:               String
    public var minOSVersion:                   String
    public var xcodeVersion:                   String
    public var xcodeBuild:                     String
    public var sdkName:                        String
    public var buildSDK:                       String
    public var buildMachineOSBuild:            String
    public var platformVersion:                String
    public var supportedPlatforms:             [String]
    public var bundleExecutable:               String
    public var bundleResourceSpecification:    String?
    public var companionAppBundleIdentifier:   String?
    public var bundleIcons:                    [String: PropertyListDictionaryValue]?
    public var bundleIconFile:                 String?
    public var bundleIconFiles:                [String]?

    
    
    public var iconName: String {
        if let bundleIcons = bundleIcons {
            
        }
        return ""
    }
}


public final class PropertyListProcessor {
    public var content: InfoPlist
    init(with path: String) {
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = PropertyListDecoder()
        self.content = try! decoder.decode(InfoPlist.self, from: data)
    }
}
