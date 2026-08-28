# W3WAPI

A lightweight, `Sendable` HTTP client for what3words REST services, built on `URLSession` with typed `async` methods, a single normalised error type (``W3WAPIError``), and Combine `Future` counterparts for reactive call sites.

## Creating a client

``W3WAPI/init(baseURL:headers:)`` takes the base URL and, optionally, headers that are sent with every request. Authentication headers are **passed in from the call site** — `W3WAPI` does not know how to authenticate, it just forwards what you give it:

```swift
var api = W3WAPI(
  baseURL: URL(string: "https://accountsapi.live.staging.w3w.io")!,
  headers: ["auth_token": token] // auth decided by the call site
)
```

`W3WAPI` is a value type — copy it and tweak the copy when a call site needs a variation (different headers, cache policy, etc.) without affecting the original.

## A sample service

A typical service owns a configured `W3WAPI` and exposes domain methods. Using the staging Accounts API as an example:

```swift
struct SavedLocationService {
  private var api: W3WAPI

  init(appKey: String, authToken: String) {
    api = W3WAPI(
      baseURL: URL(string: "https://accountsapi.live.staging.w3w.io")!,
      headers: ["key": appKey, "auth_token": authToken,]
    )
  }
}
```

@TabNavigator {
  @Tab("GET") {
    ```swift
    struct W3WLists: Decodable {
      let lists: [W3WList]
    }

    extension SavedLocationService {
      func lists() async throws(W3WAPIError) -> W3WLists {
        try await api.get("/accounts/v1/lists", for: W3WLists.self)
      }
    }
    ```
  }

  @Tab("POST") {
    ```swift
    extension SavedLocationService {
      func createList(label: String) async throws(W3WAPIError) -> W3WList {
        try await api.post(
          "/accounts/v1/lists",
          body: ["label": label],
          for: W3WList.self
        )
      }

      // When the response body doesn't matter, skip the `for:` type.
      func deleteList(id: String) async throws(W3WAPIError) {
        try await api.post("/accounts/v1/lists/\(id)/delete")
      }
    }
    ```
  }
}

## Base headers and params

``W3WAPI/headers`` and ``W3WAPI/params`` are attached to **every** request made by the client. When a request supplies its own `params`, they are merged over the base ones — the per-request value wins on a name clash:

```swift
api.params = ["key": appKey, "auth_token": authToken]

// Sends key, auth_token AND page — no need to repeat the base params.
try await api.get("/accounts/v1/lists", params: ["page": "2"], for: W3WLists.self)
```

## Decoding

Responses are decoded with a shared ``W3WAPI/decoder`` whose `keyDecodingStrategy` is `.convertFromSnakeCase`, so `Decodable` models use camelCase properties with no `CodingKeys` boilerplate — `message_code` decodes into `messageCode`.

> Note: The decoder currently has no `dateDecodingStrategy`. If an endpoint starts returning dates that need parsing (ISO 8601, epoch…), add the appropriate strategy to `JSONDecoder.default` in `W3WAPI.swift`.

## Hooks for debugging and analytics

Three optional observation hooks cover the full round trip — handy for centralised logging, analytics, or a network console:

```swift
api.onRequest = { request in
  print("➡️ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
}
api.onResponse = { data, response in
  // Called for BOTH success and error status codes, before validation/decoding.
  print("⬅️ \(response.statusCode): \(String(decoding: data, as: UTF8.self))")
}
api.onError = { error in
  analytics.track(error) // Called just before the error is thrown.
}
```

- ``W3WAPI/onRequest`` — the fully-built `URLRequest`, just before sending. Observation only; mutating it has no effect.
- ``W3WAPI/onResponse`` — raw body + `HTTPURLResponse` for every round trip, before status-code validation.
- ``W3WAPI/onError`` — the underlying error whenever a request fails, before it is thrown.

## Body encodings

``W3WAPIEncoding`` controls how the request body is serialised. In practice:

- ``W3WAPIEncoding/json`` — the default; **almost everything uses this**.
- ``W3WAPIEncoding/form`` — only the authentication endpoints (log in / sign up) use `application/x-www-form-urlencoded`.
- ``W3WAPIEncoding/multipart(files:)`` — only the file-upload part of the AI chat feature uses `multipart/form-data`, with each file described by a ``W3WAPIFilePart``.

```swift
// Auth — form encoding
try await api.post("/login", body: ["email": email, "password": password], encoding: .form, for: W3WSession.self)

// AI chat upload — multipart
let file = W3WAPIFilePart(name: "files", fileName: "voice.wav", contentType: "audio/wav", data: data)
try await api.post("/chat/upload", encoding: .multipart(files: [file]), for: W3WUploadResult.self)
```

## Prefer the convenience methods

The core entry points are `request(_:path:params:body:encoding:for:)` and its bodyless sibling, but day-to-day code reads better through the shorthands — reach for these first:

- ``W3WAPI/get(_:params:for:)-swift.method`` — GET + decode.
- ``W3WAPI/post(_:params:body:encoding:for:)`` — POST + decode.
- ``W3WAPI/post(_:params:body:encoding:)`` — POST, fire-and-forget (only success/failure matters).

Fall back to `request` directly only when you need a less common HTTP method.

## Reactive call sites

If the surrounding code is Combine-based, use the `Future`-returning counterparts in `W3WAPI+Future.swift` instead of bridging async/await yourself:

```swift
api.get("/accounts/v1/lists", for: W3WLists.self)   // Future<W3WLists, W3WAPIError>
  .sink(receiveCompletion: { ... }, receiveValue: { ... })
```

Each future emits the decoded value once, or fails with a ``W3WAPIError``.

## Working with errors

All request methods use typed throws — the **only** error type a call site ever sees is ``W3WAPIError``, so there is no casting dance:

```swift
do throws(W3WAPIError) {
  let lists = try await api.lists()
} catch {
  // `error` is already a W3WAPIError.
  switch error.code {
  case 401: promptReauthentication()
  default: showAlert(error.title)
  }
}
```

- Server error payloads (`message` / `message_code`) decode straight into `title` / `code`.
- Non-2xx responses without a decodable payload become a `W3WAPIError` built from the HTTP status code.
- Local failures (networking, decoding, bad URL) are wrapped with `code == 0`.

Good to know:

- **Session reset (code 702):** when the server invalidates the session, `W3WAPI` posts the `.w3wOnRequireSessionReset` notification on the main queue before throwing, so observers can clear local session state and re-authenticate.
- **Accepted status codes:** ``W3WAPI/acceptingCodes`` defaults to `200..<300`; widen it if an endpoint legitimately returns something else.
- **Caching:** ``W3WAPI/cachePolicy`` defaults to `.useProtocolCachePolicy` (honours server cache headers); set `.reloadIgnoringLocalCacheData` on a client that must always fetch fresh data.
