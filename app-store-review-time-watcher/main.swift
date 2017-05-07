//
//  main.swift
//  app-store-review-time-watcher
//
//  Created by Lukas Würzburger on 06.05.17.
//  Copyright © 2017 Lukas Würzburger. All rights reserved.
//

import Foundation

let storeDate = Date()

extension Int {
    var hours: Int {
        return self * 60 * 60
    }
}

struct Argument {
    var key: String
    var value: String
}

func arg(key: String) -> Argument? {
    var argument: Argument?
    if let value = CommandLine.arguments.filter({ $0.substring(to: key.characters.endIndex) == key }).first?.components(separatedBy: "=").last {
        argument = Argument(key: key, value: value)
    }
    return argument
}

func checkStatus(_ appId: String, _ callback: @escaping (_ releaseDate: String, _ version: String) -> ()) {

    let urlsession = URLSession(configuration: .default)
    let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)")!
    let task = urlsession.dataTask(with: url) { data, response, error in
        guard let data = data else { return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
        guard let json = jsonObject as? [String : Any] else { return }
        guard let results = json["results"] as? [[String : Any]] else { return }
        guard let appInfo = results.first else { return }
        guard let releaseDate = appInfo["currentVersionReleaseDate"] as? String,
            let version = appInfo["version"] as? String else { return }
        callback(releaseDate, version)
    }
    task.resume()
}

func tick() {

    if let app = arg(key: "app"),
        let version = arg(key: "version") {
        print("Requesting App \(app.value) (\(version.value)) ...")
        checkStatus(app.value) { releaseDate, version in
            let formatter = ISO8601DateFormatter()
            guard let date = formatter.date(from: releaseDate) else {
                print("Cannot parse date")
                return
            }
            if storeDate.compare(date) == .orderedAscending {
                print("New version arrived!!")
                exit(1)
            } else {
                print("The app store version is the most actual version. Waiting for update ...")
            }
        }
    }
}

repeat {
    tick()
    sleep(UInt32(5))
} while true
