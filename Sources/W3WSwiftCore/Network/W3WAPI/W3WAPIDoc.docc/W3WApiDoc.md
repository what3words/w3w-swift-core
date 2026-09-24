# W3WApi

A lightweight, `Sendable` HTTP client for what3words REST services, built on `URLSession` with typed `async` methods, a single normalised error type (``W3WError``), and Combine `Future` counterparts for reactive call sites.

## Creating a client

``W3WApi/init(baseURL:headers:params:)`` takes the base URL and, optionally, headers and query params that are sent with every request. Authentication headers are **passed in from the call site** — `W3WApi` does not know how to authenticate, it just forwards what you give it:

```swift
var api = W3WApi(
  baseURL: URL(string: "https://accountsapi.live.staging.w3w.io")!,
  params: ["auth_token": token, "key": appKey] // provided by the call site
)
```

`W3WApi` is a value type — copy it and tweak the copy when a call site needs a variation (different headers, cache policy, etc.) without affecting the original.

## A sample service

A typical service owns a configured `W3WApi` and exposes domain methods. Using the staging Accounts API as an example:

```swift
struct SavedLocationService {
  private var api: W3WApi

  init(appKey: String, authToken: String) {
    api = W3WApi(
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

``W3WApi/headers`` and ``W3WApi/params`` are attached to **every** request made by the client. When a request supplies its own `params`, they are merged over the base ones — the per-request value wins on a name clash:

```swift
api.params = ["key": appKey, "auth_token": authToken]

// Sends key, auth_token AND page — no need to repeat the base params.
try await api.get("/accounts/v1/lists", params: ["page": "2"], for: W3WLists.self)
```

## Decoding

Responses are decoded with a shared ``W3WApi/decoder`` whose `keyDecodingStrategy` is `.convertFromSnakeCase`, so `Decodable` models use camelCase properties with no `CodingKeys` boilerplate — `message_code` decodes into `messageCode`.

> Note: The decoder currently has no `dateDecodingStrategy`. If an endpoint starts returning dates that need parsing (ISO 8601, epoch…), add the appropriate strategy to `JSONDecoder.default` in `W3WApi.swift`.

> Important: Error payloads rely on that same strategy. ``W3WError``'s `Decodable` conformance reads `messageCode`, so decoding an error body with a plain `JSONDecoder` silently drops `message_code` and yields a codeless ``W3WError/message(_:)``. Decode error payloads through ``W3WApi/decoder`` (or any decoder with `.convertFromSnakeCase`).

## Body encodings

``W3WApiEncoding`` controls how the request body is serialised. In practice:

- ``W3WApiEncoding/json`` — the default; **almost everything uses this**.
- ``W3WApiEncoding/form`` — only the authentication endpoints (log in / sign up) use `application/x-www-form-urlencoded`.
- ``W3WApiEncoding/multipart(files:)`` — only the file-upload part of the AI chat feature uses `multipart/form-data`, with each file described by a ``W3WApiFilePart``.

```swift
// Auth — form encoding
try await api.post("/login", body: ["email": email, "password": password], encoding: .form, for: W3WSession.self)

// AI chat upload — multipart
let file = W3WApiFilePart(name: "files", fileName: "voice.wav", contentType: "audio/wav", data: data)
try await api.post("/chat/upload", encoding: .multipart(files: [file]), for: W3WUploadResult.self)
```

## Prefer the convenience methods

The core entry points are `request(_:path:params:body:encoding:for:)` and its bodyless sibling, but day-to-day code reads better through the shorthands — reach for these first:

- ``W3WApi/get(_:params:for:)-swift.method`` — GET + decode.
- ``W3WApi/post(_:params:body:encoding:for:)`` — POST + decode.
- ``W3WApi/post(_:params:body:encoding:)`` — POST, fire-and-forget (only success/failure matters).

Fall back to `request` directly only when you need a less common HTTP method.

## Reactive call sites

If the surrounding code is Combine-based, use the `Future`-returning counterparts in `W3WApi+Future.swift` instead of bridging async/await yourself:

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

- **Session expiry (code 702):** handled specially — see <doc:W3WApiDoc#Session-expiry-code-702> below.
- **Accepted status codes:** ``W3WApi/acceptingCodes`` defaults to `200..<300`; widen it if an endpoint legitimately returns something else.
- **Caching:** ``W3WApi/cachePolicy`` defaults to `.useProtocolCachePolicy` (honours server cache headers); set `.reloadIgnoringLocalCacheData` on a client that must always fetch fresh data.

## Session expiry (code 702)

Message code 702 means the server has invalidated the session: every subsequent request with that token will fail until the user re-authenticates. It is the one error `W3WApi` does more than throw — it also broadcasts on ``W3WSessionEvents/onExpiration`` (on the main queue) before the throw, so state that lives far from the call site can be cleared in one place.

Catching and observing are complementary, not exclusive: the error is *always* thrown, whether or not anyone observes the event. Pick where each concern lives — three options, and a call site may well use more than one.

| Approach | Reach | Use it for |
|---|---|---|
| Catch at the call site | Only the call that failed | One screen reacting to its own request |
| ``W3WSessionEvents/shared`` | Every `W3WApi` in the process | App-wide sign-out — **recommended for the main app** |
| Injected ``W3WSessionEvents`` | Only clients you gave it to | A feature module that resolves expiry itself, and tests |

### Catching it at the call site

Nothing to subscribe to — 702 arrives as an ordinary ``W3WError/code(_:_:)``:

```swift
do throws(W3WError) {
  let lists = try await api.lists()
} catch {
  if error.code == 702 {
    // Handle it here and now: this screen's own retry / sign-in prompt.
    await reauthenticateAndRetry()
  } else {
    showAlert(String(describing: error))
  }
}
```

Use this when the response belongs to one screen or flow. It does not scale to an app-wide sign-out: every call site would have to repeat the check, and whichever request loses the race would clear session state twice.

### Observing W3WSessionEvents.shared — recommended for the main app

Subscribe once, typically where session state is owned, and every `W3WApi` in the process feeds into it — no matter which service made the request:

```swift
final class W3WAppServices {
  private var sessionEvents = W3WSessionEvents.shared

  init() {
    subscribe(to: sessionEvents.onExpiration) { [weak self] in
      self?.clearCachedSession() // keychain, tokens, user defaults
      self?.routeToSignIn()
    }
  }
}
```

Worth knowing about the delivery:

- Events land on the **main queue**, so UI work needs no extra hop.
- ``W3WSessionEvents/onExpiration`` is an event, not a value — nothing is replayed to late subscribers. Subscribe during setup, before the first request.
- Delivery is asynchronous, so a `catch` block at the call site normally runs first. Don't split one decision across both places; let the call site show its own error, and the observer own the sign-out.
- Only ``W3WApi`` can broadcast — app code can subscribe but never send, so an expiry event always means a real 702.
- Concurrent requests each broadcast, so two in-flight calls hitting 702 produce two events. Make the handler idempotent, or gate it on "am I already signing out?".

### Injecting an instance to keep expiry internal

``W3WApi/sessionEvents`` defaults to ``W3WSessionEvents/shared``, but points anywhere you like. Give a client its own instance and its 702s stop reaching the shared broadcaster:

```swift
final class SavedLocationService {
  private var api: W3WApi
  // This module's own broadcaster — never leaks to W3WSessionEvents.shared.
  private let sessionEvents = W3WSessionEvents()

  init(appKey: String, authToken: String) {
    api = W3WApi(baseURL: baseURL, params: ["key": appKey, "auth_token": authToken])
    api.sessionEvents = sessionEvents   // assign before copying `api` around

    subscribe(to: sessionEvents.onExpiration) { [weak self] in
      self?.refreshTokenAndResume()
    }
  }
}
```

Reach for this when a framework or feature module can resolve expiry on its own (it holds the refresh token, or runs on a service account) and should not trigger the host app's sign-out. The same trick isolates tests: give the client under test a fresh ``W3WSessionEvents`` so assertions can't be disturbed by anything else in the process.

> Important: `W3WApi` is a value type, so `sessionEvents` is captured by each copy. Assign it before handing copies to other code — a copy made earlier keeps whatever broadcaster it was created with.
