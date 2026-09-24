# W3WAPI

A lightweight, `Sendable` HTTP client for what3words REST services, built on `URLSession` with typed `async` methods, a single normalised error type (``W3WError``), and Combine `Future` counterparts for reactive call sites.

## Creating a client

``W3WAPI/init(baseURL:headers:params:)`` takes the base URL and, optionally, headers and query params that are sent with every request. Authentication headers are **passed in from the call site** — `W3WAPI` does not know how to authenticate, it just forwards what you give it:

```swift
var api = W3WAPI(
  baseURL: URL(string: "https://accountsapi.live.staging.w3w.io")!,
  params: ["auth_token": token, "key": appKey] // provided by the call site
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
      params: ["key": appKey, "auth_token": authToken]
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
      func lists() async throws(W3WError) -> W3WLists {
        try await api.get("/accounts/v1/lists", for: W3WLists.self)
      }
    }
    ```
  }

  @Tab("POST") {
    ```swift
    extension SavedLocationService {
      func createList(label: String) async throws(W3WError) -> W3WList {
        try await api.post(
          "/accounts/v1/lists",
          body: ["label": label],
          for: W3WList.self
        )
      }

      // When the response body doesn't matter, skip the `for:` type.
      func deleteList(id: String) async throws(W3WError) {
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

> Important: Error payloads rely on that same strategy. ``W3WError``'s `Decodable` conformance reads `messageCode`, so decoding an error body with a plain `JSONDecoder` silently drops `message_code` and yields a codeless ``W3WError/message(_:)``. Decode error payloads through ``W3WAPI/decoder`` (or any decoder with `.convertFromSnakeCase`).

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
api.get("/accounts/v1/lists", for: W3WLists.self)   // Future<W3WLists, W3WError>
  .sink(receiveCompletion: { ... }, receiveValue: { ... })
```

Each future emits the decoded value once, or fails with a ``W3WError``.

## Working with errors

All request methods use typed throws — the **only** error type a call site ever sees is ``W3WError``, so there is no casting dance:

```swift
do throws(W3WError) {
  let lists = try await api.lists()
} catch {
  // `error` is already a W3WError — switch on the case that interests you.
  switch error {
  case .code(401, _):                  promptReauthentication()
  case .code(let code, let message):   log("request failed \(code): \(message)")
  case .message(let message):          showAlert(message)
  case .other(let underlying):         showAlert(underlying?.localizedDescription ?? "Network error")
  case .unknown:                       showAlert("Something went wrong")
  }
}
```

When only the code matters, ``W3WError/code-swift.property`` is the shorthand — it is `nil` for every case except ``W3WError/code(_:_:)``:

```swift
if error.code == 702 { resetSession() }
```

How each failure maps onto the enum:

| Failure | Case | `error.code` |
|---|---|---|
| Error payload with `message` + `message_code` | `.code(messageCode, message)` | the server's message code |
| Error payload with `message` only | `.message(message)` | `nil` |
| Non-2xx response with no decodable payload | `.code(statusCode, localizedStatusDescription)` | the HTTP status code |
| Local failure (networking, decoding, bad URL) | `.other(error)` | `nil` |

Two things to keep in mind:

- Server message codes and HTTP status codes share the same ``W3WError/code-swift.property`` space, so a check like `error.code == 401` may match either. Pair it with the message when the distinction matters.
- ``W3WError`` is `CustomStringConvertible`, and `.code` renders as `"702: Session expired"` — code prefix included. Show the associated message itself when the UI needs clean user-facing text.

Good to know:

- **Session reset (code 702):** when the server invalidates the session, `W3WAPI` posts the `.w3wOnRequireSessionReset` notification on the main queue before throwing, so observers can clear local session state and re-authenticate.
- **Accepted status codes:** ``W3WAPI/acceptingCodes`` defaults to `200..<300`; widen it if an endpoint legitimately returns something else.
- **Caching:** ``W3WAPI/cachePolicy`` defaults to `.useProtocolCachePolicy` (honours server cache headers); set `.reloadIgnoringLocalCacheData` on a client that must always fetch fresh data.
