import XCTest
@testable import GPTChat

@available(macOS 12.0, *)
class GPTChatAPITests: XCTestCase {

    var sut: GPTChatAPI!
    
    override func setUp() {
        super.setUp()
        sut = GPTChatAPI(apiKey: "mockApiKey")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testChatRequestEncoding() throws {
        let message = GPTMessage(role: "user", content: "Hello")
        let request = GPTChatRequest(model: "gpt-3.5-turbo", messages: [message])
        let jsonData = try JSONEncoder().encode(request)
        XCTAssertNotNil(jsonData)
    }
    
    func testChatResponseDecoding() throws {
        let json = """
        {
            "id": "mockId",
            "object": "chat.completion",
            "created": 1634000000,
            "model": "gpt-3.5-turbo",
            "usage": {
                "prompt_tokens": 10,
                "completion_tokens": 20,
                "total_tokens": 30
            },
            "choices": [
                {
                    "message": {
                        "role": "assistant",
                        "content": "Hello"
                    },
                    "finish_reason": "stop",
                    "index": 0
                }
            ]
        }
        """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(GPTChatResponse.self, from: json)
        XCTAssertEqual(response.id, "mockId")
        XCTAssertEqual(response.choices.first?.message.content, "Hello")
    }
    
    // Additional tests can be added to mock URLSession and test the `chat(withMessages:)` method.
}
