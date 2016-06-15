# Fetcher

"The most fun you'll have with a networking API in Swift!" - Author of this library

## Overview

This library implements the [WHAT-WG Fetch API](https://fetch.spec.whatwg.org/) in Swift. I started it as a project to learn this language while doing something (hopefully) useful. Since the fetch API will become common in browsers and web application programming, it seemed like a good project to use to "kick the tires" in Swift.

In addition, the fetch API makes use of Promises, so that was also a fun thing to learn.

## Installing

For now, you need to include the files in your project, or reference the Xcode project.

## How It Works

Fetcher defines a protocol, `Fetch`, with a method that implements the mechanics of a fetch. The primary implementation is provided by an extension to `NSURLSession`, which is the standard API for networking on macOS and iOS.

The return value to a `fetch()` call is a Promise of a `Response`. A Promise is a data structure used commonly in JavaScript and other environments; it models an asynchronous operation which returns a value in the future. It supports chaining and error handling. More information on promises can be found on the [MDN Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) page.

## Examples

The simplest example is making a fetch and accessing the response data as JSON. The JSON is the standard `AnyObject` representation returned by `NSJSONSerialization`.

    fetch("https://api.github.com")
      .then { (response) in response.json() }
      .then { (json) -> AnyObject in 
        print(json)
        return json
      }
      catch_ { (error) in 
        print(error)
      }

In addition to the URL, you can specify several kinds of options for the request. For example, to change the HTTP method used:

    fetch("https://api.github.com", RequestInit(method: .HEAD))
      .then { (response) -> Response in
         print(response.headers.get("Content-Type"))
         return response
      }
      
You can ask for JSON and verify it's there. (Note that the test for equality with the string 'application/json' is not completely correct since MIME types have special rules for equality checks.)

    fetch("https://api.github.com", RequestInit(headers: Headers(["Accept": "application/json"])))
      .then { (response) in 
        if (response.headers.get("Content-Type")! != "application/json") {
            throw MyError("Not JSON!")
        }
        return response.json() 
      }
      .then { (json) -> AnyObject in 
        print(json)
        return json
      }


## License

This library is licensed under the new BSD license.
