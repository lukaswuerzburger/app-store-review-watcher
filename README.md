app-store-review-watcher
===========

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)

A script that watches the Apple App Store for a new version of a specific app after it got released.

How to use
--------

You would simply trigger the script right after the submission for review.
Pass `app` which is the apple_id of the app and the new marketing `version`.

```
path-to-binary/app-store-review-time-watcher app=123456789 version=1.0.1
```

### Hook into [fastlane](https://github.com/fastlane/fastlane)

The project was created in a context of using [fastlane](https://github.com/fastlane/fastlane) as a deployment tool. So you could simply trigger a function right after `deliver`.

