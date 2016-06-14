# Fetcher

"The most fun you'll have with a networking API in Swift!" - Author of this library

## Overview

This library implements the WHAT-WG Fetch API in Swift. I started it as a project to learn this language while doing something (hopefully) useful. Since the fetch API will become common in browsers and web application programming, it seemed like a good project to use to "kick the tires" in Swift.

In addition, the fetch API makes use of Promises, so that was also a fun thing to learn.

## Installing

For now, you need to include the files in your project, or reference the Xcode project.

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

## Playground

