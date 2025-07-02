import Foundation

extension FileManager {
    func decodeDocumentsDirectory<T: Codable>(_ file: String) throws -> T {
        let url = self.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: file)
        
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return try decoder.decode(T.self, from: data)
    }
}

