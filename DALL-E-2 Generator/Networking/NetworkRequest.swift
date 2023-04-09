import Foundation

class NetworkRequest {
    
    // Encode sent data
    struct MyJasonObject: Codable {
        let prompt: String
    }
    
    // Decode received data
    struct ReceivedData: Codable {
        let created: Int
        let data: [RawImageURL]
    }
    
    struct RawImageURL: Codable {
        let url: String
    }

    static func postRequest(prompt: String) async throws -> String {

        // Prepare prompt for sending the post request
        let myJasonObject = MyJasonObject(prompt: prompt)
        let payload = try JSONEncoder().encode(myJasonObject)

        // Prepare the URL request
        guard let url = URL(string:"https://api.openai.com/v1/images/generations") else {
            fatalError("Cannot make the URL request")
        }
        var urlRequest = URLRequest(url: url)
        let appKey = Bundle.main.object(forInfoDictionaryKey: "IMAGE_API_KEY") as? String
        urlRequest.addValue("Bearer \(appKey!)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"

        // Wait and process Server feedback
        let (data, _) = try await URLSession.shared.upload(for: urlRequest, from: payload)
        let successInfo = try JSONDecoder().decode(ReceivedData.self, from: data)
        let imageURL = successInfo.data[0].url

        // return the image URL
        return imageURL
    }
}
