//
//  INFileManager.swift
//  NexarLocationTest
//
//  Created by Ruslan Ponomarenko on 1/18/22.
//

import Foundation

protocol INFileManagerDT {
    func addLogToFile(longitude: Double, latitude: Double )
    static func getFiles(aturl:URL)->[(URL,String)]
    static func deleteFile(atUrl: URL)
}

///File Manager
class INFileManager: INFileManagerDT  {
  
    private var currentFileName: String?
    private let baseFolder: URL
    private let namePublisher:NamePublisher
    
    init(namePublisher: NamePublisher, baseFolder: URL ){
        self.baseFolder = baseFolder
        self.namePublisher = namePublisher
        self.namePublisher.startTiming { name in
            self.currentFileName = name
        }
        
    }
    
    
    /// Add Log to file
    /// We will create log file only if information present
    func addLogToFile(longitude: Double, latitude: Double ){
        let stDate = Date().formatted(date: .numeric, time: .standard)
        let logString = "#\(stDate)  (\(longitude),\(latitude)) "
        guard let currentFileName = self.currentFileName ,
              let data = logString.data(using: String.Encoding.utf8) else {
                  return
              }
        let fileURL = baseFolder.appendingPathComponent(currentFileName)
        print (fileURL.absoluteString)
        do {
            try data.append(fileURL: fileURL)
            }
        catch {
            print("Could not write to file")
        }
        
    }
    
    //Get all files of the root folder
    static func getFiles(aturl:URL)->[(URL,String)]{
         var results:[(URL,String)]=[]
         results.append((aturl,aturl.lastPathComponent))
        let resourceKeys : [URLResourceKey] = [.creationDateKey,.isDirectoryKey]
         do {
             
             let enumerator = FileManager.default.enumerator(at: aturl,
                                                             includingPropertiesForKeys: resourceKeys,
                                                             options: [.skipsHiddenFiles,], errorHandler: { (url, error) -> Bool in
                                                                 print("directoryEnumerator error at \(url): ", error)
                                                                 return true
             })!
             
             let rootpathcount:[String]=aturl.pathComponents;
             for case let fileURL as URL in enumerator {
                 
                 let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                 if (!resourceValues.isDirectory!){
                     
                     let tmppathcount:[String]=fileURL.pathComponents;
                     let header=String(repeating: "   ", count: (tmppathcount.count-rootpathcount.count))
                     results.append((fileURL,header+fileURL.lastPathComponent))
                     print(header+fileURL.lastPathComponent)
                 }
                 
             }
         } catch {
             print(error)
         }
        
         return results
     }
     
    
    ///Deleting File with URL
    static func deleteFile(atUrl: URL){
        DispatchQueue.global().async {
        if FileManager.default.fileExists(atPath: atUrl.path) {
            // delete file
            do {
                try FileManager.default.removeItem(atPath: atUrl.path)
            } catch {
                print("Could not delete file, probably read-only filesystem")
            }
        }
     }
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
