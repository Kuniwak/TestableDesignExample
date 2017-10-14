import Foundation


/**
 JSON をファイルパスから読み込む関数の名前空間。
 */
struct JsonReader {
    /**
     JSON ファイルから辞書を読み込みます。

     # 例

     ```
     let dict = JsonReader.dictionary(from: R.file.exampleJson.path()!)
     ```

     - parameters:
        - path: JSON ファイルのファイルパス。
     - returns: 読み込まれた辞書。
     */
    static func dictionary(from path: String) -> [String: Any] {
        let fileHandle = FileHandle(forReadingAtPath: path)!
        let data = fileHandle.readDataToEndOfFile()

        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json as! [String: Any]
    }


    /**
     JSON ファイルから配列を読み込みます。

     # 例

     ```
     let array = JsonReader.array(from: R.file.exampleJson.path()!)
     ```

     - parameters:
        - path: JSON ファイルのファイルパス。
     - returns: 読み込まれた配列。
     */
    static func array(from path: String) -> [AnyObject] {
        let fileHandle = FileHandle(forReadingAtPath: path)!
        let data = fileHandle.readDataToEndOfFile()

        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        return json as! [AnyObject]
    }
}
