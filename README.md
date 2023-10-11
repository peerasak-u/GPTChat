# GPTChat

A Swift Package for interacting with OpenAI's GPT models

## Features
- Asynchronous API calls using Swift's native `async/await`.
- Strongly-typed models for requests and responses.
- Supports macOS 12.0 and above.

## Installation

### Swift Package Manager

You can install `GPTChat` via [Swift Package Manager](https://swift.org/package-manager/) by adding the package to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/[YourGitHubUsername]/GPTChat.git", from: "1.0.0"),
]
```

Then, add `GPTChat` to your targets:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["GPTChat"]),
]
```

## Usage

Firstly, import the package in your file:

```swift
import GPTChat
```

### Initialize the API Client

```swift
let gptChatAPI = GPTChatAPI(apiKey: "YOUR_OPENAI_API_KEY", model: "gpt-3.5-turbo")
```

### Making a Chat Request

```swift
let systemMessage = GPTMessage(role: "system", content: "You are a helpful assistant.")
let userMessage = GPTMessage(role: "user", content: "Who won the world series in 2020?")

Task {
    do {
        let response = try await gptChatAPI.chat(withMessages: [systemMessage, userMessage])
        print(response.choices.first?.message.content ?? "No response")
    } catch {
        print("Error:", error.localizedDescription)
    }
}
```

## Contributing

Feel free to open issues or pull requests with improvements or bug fixes.



