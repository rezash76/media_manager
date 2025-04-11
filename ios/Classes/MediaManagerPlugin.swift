import Flutter
import UIKit
import Photos

public class MediaManagerPlugin: NSObject, FlutterPlugin {
    private var imageCache = NSCache<NSString, UIImage>()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "media_manager", binaryMessenger: registrar.messenger())
        let instance = MediaManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "getDirectories":
            getDirectories(result: result)

        case "getDirectoryContents":
            if let args = call.arguments as? [String: Any],
               let path = args["path"] as? String {
                getDirectoryContents(path: path, result: result)
            } else {
                result(FlutterError(code: "INVALID_PATH",
                                  message: "Invalid directory path",
                                  details: nil))
            }

        case "getImagePreview":
            if let args = call.arguments as? [String: Any],
               let path = args["path"] as? String {
                getImagePreview(path: path, result: result)
            } else {
                result(FlutterError(code: "INVALID_PATH",
                                  message: "Invalid image path",
                                  details: nil))
            }

        case "clearImageCache":
            clearImageCache()
            result(true)

        case "requestStoragePermission":
            requestStoragePermission(result: result)

        case "getAllImages":
            getAllFilesByType(result: result, extensions: ["jpg", "jpeg", "png", "gif", "bmp", "webp"])

        case "getAllVideos":
            getAllFilesByType(result: result, extensions: ["mp4", "mov", "m4v"])

        case "getAllAudio":
            getAllFilesByType(result: result, extensions: ["mp3", "wav", "m4a"])

        case "getAllDocuments":
            let documentExtensions = [
                // Document formats
                "pdf", "doc", "docx", "docm", "dot", "dotx", "dotm",
                "txt", "rtf", "odt", "ott", "odm", "oth",
                "xml", "html", "htm", "xhtml", "mhtml",
                "epub", "mobi", "azw", "fb2",

                // Spreadsheet formats
                "xls", "xlsx", "xlsm", "xlsb", "xlt", "xltx", "xltm",
                "ods", "ots", "csv",

                // Presentation formats
                "ppt", "pptx", "pptm", "pps", "ppsx", "ppsm",
                "pot", "potx", "potm", "odp", "otp",

                // Programming/Code files
                "dart", "php", "js", "jsx", "ts", "tsx", "py", "java",
                "kt", "kts", "cpp", "c", "h", "hpp", "cs", "go", "rb",
                "swift", "m", "mm", "sh", "bash", "ps1", "bat", "cmd",
                "pl", "pm", "lua", "sql", "json", "yaml", "yml", "toml",
                "ini", "cfg", "conf", "gradle", "properties", "asm",
                "s", "v", "vhdl", "verilog", "r", "d", "f", "f90",
                "coffee", "scala", "groovy", "clj", "cljc", "cljs",
                "edn", "ex", "exs", "elm", "erl", "hrl", "fs", "fsx",
                "fsi", "ml", "mli", "nim", "pde", "pp", "pas", "lisp",
                "cl", "scm", "ss", "rkt", "st", "tcl", "vhd", "vhdl",

                // Web development
                "vue", "svelte", "astro", "php", "phtml", "twig",
                "mustache", "hbs", "ejs", "haml", "scss", "sass",
                "less", "styl", "stylus", "coffee", "litcoffee",
                "graphql", "gql", "wasm", "wat",

                // CAD/Design files
                "dwg", "dxf", "dgn", "stl", "obj", "3ds", "max", "blend",
                "skp", "ai", "psd", "eps", "svg", "fig", "xd", "indd",
                "cdr", "afdesign", "afphoto", "afpub", "sketch", "ase",
                "aseprite", "clip", "csp", "kra", "pdn", "procreate",
                "xcf", "pd", "ps", "psb",

                // Archive formats
                "zip", "rar", "7z", "tar", "gz", "bz2", "xz", "lz",
                "lzma", "lzh", "arj", "cab", "iso", "img", "dmg",
                "pkg", "deb", "rpm", "msi", "crx",

                // Ebook formats
                "djvu", "chm", "oxps", "xps", "cbr", "cbz", "cb7",
                "cbt", "cba", "ibooks",

                // Database files
                "db", "sqlite", "sqlite3", "mdb", "accdb", "frm", "myd",
                "myi", "ibd", "mdf", "ldf", "sdf", "nsf", "kdbx",
                "gdb", "fp7", "neo", "db3",

                // Other common document formats
                "md", "markdown", "tex", "log", "pages", "wpd", "wps",
                "abw", "zabw", "123", "602", "wk1", "wk3", "wk4", "wq1",
                "wq2", "xlw", "pmd", "sxw", "stw", "vor", "sxg", "otg",
                "odg", "odc", "odf", "odi", "oxt", "sxc", "stc", "sxd",
                "std", "sxi", "sti", "sxm", "mml", "smf", "odfl", "hwp",
                "hwt", "cell", "numbers", "key", "numbers-tef", "key-tef",
                "papers", "uof", "uot", "uos", "uop", "wmf", "emf", "cgm",
                "vsd", "vsdx", "vss", "vst", "vdx", "vsdm", "vssm", "vstm",
                "pub", "xpub", "sldprt", "sldasm", "slddrw", "prt", "asm",
                "drw", "f3d", "f3z", "iam", "ipt", "catproduct", "catpart",
                "catdrawing", "cgr", "dlv", "exp", "model", "par", "psm",
                "pwd", "session", "sim", "sldlfp", "sldlfp", "std", "stl",
                "stp", "unv", "xas", "xpr", "3dm", "3mf", "amf", "dae",
                "fbx", "glb", "gltf", "iges", "igs", "jt", "obj", "ply",
                "stp", "step", "vrml", "wrl", "x3d", "x3db", "x3dv", "xgl",
                "zgl", "bim", "ifc", "dwf", "dwfx", "nwd", "nwf", "nwc",
                "pln", "pla", "pod", "skb", "layout", "template", "lcd",
                "max", "ma", "mb", "hip", "hiplc", "hda", "hdanc", "usd",
                "usda", "usdc", "usdz", "abc", "vdb", "bgeo", "geo", "pc",
                "pdc", "pdb", "ptc", "rib", "rs", "sc", "scn", "v", "veg",
                "vfb", "vfz", "vob", "vpe", "vray", "vrmesh", "vscene",
                "vue", "w3d", "wings", "wrl", "x", "x3d", "x3dv", "xsi",
                "zbrush"
            ]
            getAllFilesByType(result: result, extensions: documentExtensions)

        case "getAllZipFiles":
            getAllFilesByType(result: result, extensions: ["zip", "rar"])

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getDirectories(result: @escaping FlutterResult) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let homePath = documentsPath.deletingLastPathComponent()

        do {
            let contents = try fileManager.contentsOfDirectory(at: homePath,
                                                              includingPropertiesForKeys: nil,
                                                              options: [.skipsHiddenFiles])

            let directories = contents.filter { $0.hasDirectoryPath }
                .map { url -> [String: Any] in
                    return [
                        "name": url.lastPathComponent,
                        "path": url.path
                    ]
                }
                .sorted { ($0["name"] as! String) < ($1["name"] as! String) }

            result(directories)
        } catch {
            result(FlutterError(code: "DIRECTORY_ACCESS_ERROR",
                              message: error.localizedDescription,
                              details: nil))
        }
    }

    private func getDirectoryContents(path: String, result: @escaping FlutterResult) {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: path)

        do {
            var resourceKeys: [URLResourceKey] = [.fileSizeKey]
            if #available(iOS 14.0, *) {
                resourceKeys.append(.contentTypeKey)
            }
            
            let contents = try fileManager.contentsOfDirectory(at: directoryURL,
                                                              includingPropertiesForKeys: resourceKeys,
                                                              options: [.skipsHiddenFiles])

            let items = contents.map { url -> [String: Any] in
                let isDirectory = url.hasDirectoryPath
                let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
                let extension = url.pathExtension.lowercased()

                var item: [String: Any] = [
                    "name": url.lastPathComponent,
                    "path": url.path,
                    "isDirectory": isDirectory,
                    "type": isDirectory ? "directory" : getFileType(extension),
                    "extension": extension,
                    "readableSize": formatFileSize(fileSize ?? 0)
                ]

                return item
            }
            .sorted { (($0["isDirectory"] as! Bool) && !($1["isDirectory"] as! Bool)) ||
                     (($0["isDirectory"] as! Bool) == ($1["isDirectory"] as! Bool) &&
                      ($0["name"] as! String) < ($1["name"] as! String)) }

            result(items)
        } catch {
            result(FlutterError(code: "FILE_ACCESS_ERROR",
                              message: error.localizedDescription,
                              details: nil))
        }
    }

    private func getImagePreview(path: String, result: @escaping FlutterResult) {
        if let cachedImage = imageCache.object(forKey: path as NSString) {
            if let imageData = cachedImage.jpegData(compressionQuality: 0.9) {
                result(imageData)
                return
            }
        }

        if let image = UIImage(contentsOfFile: path) {
            let resizedImage = resizeImage(image, targetSize: CGSize(width: 800, height: 800))
            imageCache.setObject(resizedImage, forKey: path as NSString)

            if let imageData = resizedImage.jpegData(compressionQuality: 0.9) {
                result(imageData)
            } else {
                result(FlutterError(code: "IMAGE_COMPRESSION_ERROR",
                                  message: "Failed to compress image",
                                  details: nil))
            }
        } else {
            result(FlutterError(code: "IMAGE_LOAD_ERROR",
                              message: "Failed to load image",
                              details: nil))
        }
    }

    private func clearImageCache() {
        imageCache.removeAllObjects()
    }

    private func requestStoragePermission(result: @escaping FlutterResult) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                result(status == .authorized)
            }
        }
    }

    private func getAllFilesByType(result: @escaping FlutterResult, extensions: [String]) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let homePath = documentsPath.deletingLastPathComponent()

        var files: [String] = []

        func scanDirectory(_ url: URL) {
            do {
                let contents = try fileManager.contentsOfDirectory(at: url,
                                                                  includingPropertiesForKeys: nil,
                                                                  options: [.skipsHiddenFiles])

                for item in contents {
                    if item.hasDirectoryPath {
                        scanDirectory(item)
                    } else if extensions.contains(item.pathExtension.lowercased()) {
                        files.append(item.path)
                    }
                }
            } catch {
                print("Error scanning directory: \(error.localizedDescription)")
            }
        }

        scanDirectory(homePath)
        result(files)
    }

    private func getFileType(_ extension: String) -> String {
        switch `extension` {
        case "jpg", "jpeg", "png", "gif", "bmp", "webp":
            return "image"
        case "mp4", "mov", "m4v":
            return "video"
        case "mp3", "wav", "m4a":
            return "audio"
        case "pdf", "doc", "docx", "txt", "rtf":
            return "document"
        case "zip", "rar":
            return "zip"
        default:
            return "other"
        }
    }

    private func formatFileSize(_ size: Int64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB"]
        var fileSize = Double(size)
        var unitIndex = 0

        while fileSize >= 1024 && unitIndex < units.count - 1 {
            fileSize /= 1024
            unitIndex += 1
        }

        return String(format: "%.2f %@", fileSize, units[unitIndex])
    }

    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let ratio = min(widthRatio, heightRatio)

        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? image
    }
}