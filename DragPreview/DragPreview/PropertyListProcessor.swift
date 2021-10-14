
import Foundation


public struct InfoPlist: Codable {
    
    enum CodingKeys: String, CodingKey {
        case bundleName                   = "CFBundleName"
        case bundleDisplayName            = "CFBundleDisplayName"
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
    public var bundleDisplayName:              String
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

    public var iconName: String? {
        var findIconName: String = ""
        
        var findIcons: [String] = [String]()
        if let bundleIcons = bundleIcons {
            let primaryIcon = bundleIcons["CFBundlePrimaryIcon"]
            if case .dictionary (let dictionary) = primaryIcon {
                if case .array (let array) = dictionary["CFBundleIconFiles"] {
                    for item in array {
                        if case .string(let iconName) = item {
                            findIcons.append(iconName)
                        }
                    }
                }
            }
        }
        
        if findIcons.isEmpty {
            if let bundleIconFiles = bundleIconFiles {
                findIcons.append(contentsOf: bundleIconFiles)
            }
        }
        
        if findIcons.isEmpty == false {
            for match in ["120","60","@2x"] {
                let result = findIcons.filter{ $0.contains(match)}
                if result.isEmpty == false {
                    let firstIcon = result.last!
                    if match == "60" && firstIcon.pathExtension.isEmpty {
                        if firstIcon.hasSuffix("@2x") == false {
                            findIconName = firstIcon + "@2x"
                            break
                        }
                    }
                }
            }
            
            if findIconName.isEmpty {
                findIconName = findIcons.last!
            }
            
        } else {
            if let bundleIconFile = bundleIconFile {
                findIconName = bundleIconFile
            }
        }
        
        if findIconName.isEmpty == false  && findIconName.pathExtension.isEmpty {
            findIconName += ".png"
        }
        return findIconName
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
