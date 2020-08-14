# TestUtils

The `TestUtils` package contains the following to make testing quicker and more standardized:
- `NetworkSessionMock` to set custom network responses and errors.

## Add the Package

To use this package in your Swift project, add the following dependency:

`.package(url: "https://github.com/1904labs/ios-test-utils.git", from 1.0.0)`

To use this package in your Xcode project, select `File > Swift Package > Add Package Dependency` and enter the following URL:

`https://github.com/1904labs/ios-test-utils.git`

## How to Use

This package contains `URLProtocol` mock that you can use to replace the default `URLSession` configuration.
```swift
let config = URLSessionConfiguration.ephemeral
config.protocolClasses = [URLProtocolMock.self]
let sessionMock = URLSession(configuration: config)
```

Although you have the power to create your own `URLSession` configurations, but we have already provided a basic example that you can use if you don't need any special settings.
```swift
public var urlSessionMock: URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolMock.self]
    let session = URLSession(configuration: configuration)
    return session
}
```

### Examples
As an example, let's look at how we could test a view model making a `POST` login request to the networking layer. 

Here's the view model in question:
```swift
class UserViewModel {
    var user: User?
    var token: String?
    
    func fetchUser(username: String, password: String, completion: @escaping (Result<User,Error>) -> ()) {
        NetworkManager.shared.login(username: username, password: password, completion: { result in
            switch result {
            case .success(let user, let token):
                self.user = user
                self.token = token
                completion(.success(user))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        })
    }
}
```

Here's the supporting classes:
```swift
struct User: Codable {
    let firstName: String
    let lastName: String
}

enum NetworkError: Error {
    case noToken
    case decodingError
}

class NetworkManager {
    private init() { }
    
    public static var shared = NetworkManager()
    var session = URLSession.shared
    
    func login(username: String, password: String, completion: @escaping (Result<(User, token: String),Error>) -> ()) {
        // Make network calls
        let loginURL = URL(string: "[Some URL]")!
        var request = URLRequest(url: loginURL)
        let body = [
            "username": username,
            "password": password
        ]
        request.httpBody = try! JSONEncoder().encode(body)
        
        self.session.dataTask(with: request, completionHandler: { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            guard let token = httpResponse?.allHeaderFields["TOKEN"] as? String else {
                return completion(.failure(NetworkError.noToken))
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data!)
                return completion(.success((user, token)))
            } catch {
                return completion(.failure(NetworkError.decodingError))
            }
            
        })
    }
}
```

And here's how we might test that code:
```swift
var viewModel = UserViewModel()

func testExample() throws {
    NetworkManager.shared.session = urlSessionMock
    
    let url = URL(string: "[Some URL]")!
    
    let expectedFirstName = "John"
    let expectedLastName = "Doe"
    let expectedToken = "SomeToken"
    let expectedUser = User(firstName: "John", lastName: "Doe")
    let data = try! JSONEncoder().encode(expectedUser)
    
    let headerFields: [String:String] = [
        "TOKEN": expectedToken
    ]
    
    URLProtocolMock.testURLs = [
        url: [(data, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headerFields), nil)]
    ]
    
    let delayExpectation = expectation(description: "Waiting for task")
    viewModel.fetchUser(username: "John", password: "Doe", completion: { result in
        delayExpectation.fulfill()
    })
    waitForExpectations(timeout: 3, handler: nil)
    
    // Perform assertions
    XCTAssertEqual(viewModel.user?.firstName, expectedFirstName)
    XCTAssertEqual(viewModel.user?.lastName, expectedLastName)
    XCTAssertEqual(viewModel.token, expectedToken)
}
```
