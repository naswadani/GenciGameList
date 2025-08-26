//
//  DetailGameLocalDataSource.swift
//  GenciGameList
//
//  Created by naswakhansa on 26/08/25.
//

import Foundation
import RealmSwift

public protocol DetailGameLocalDataSourceProtocol {
    func saveGameDetail(_ obj: GameDetailObject) throws
    func getGameDetail(id: Int) -> GameDetailObject?
    func clearAllCache() throws
}

public final class DetailGameLocalDataSource: DetailGameLocalDataSourceProtocol {
    private let realm: Realm

    public init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    public func saveGameDetail(_ obj: GameDetailObject) throws {
        try realm.write {
            realm.add(obj, update: .modified)

            obj.platforms.forEach { platformObj in
                if let detail = platformObj.platform {
                    realm.add(detail, update: .modified)
                }
            }
            obj.developers.forEach { realm.add($0, update: .modified) }
            obj.genres.forEach { realm.add($0, update: .modified) }
        }
    }

    public func getGameDetail(id: Int) -> GameDetailObject? {
        realm.object(ofType: GameDetailObject.self, forPrimaryKey: id)?.freeze()
    }

    public func clearAllCache() throws {
        try realm.write {
            realm.delete(realm.objects(GameDetailObject.self))
            realm.delete(realm.objects(DeveloperObject.self))
            realm.delete(realm.objects(PlatformObject.self))
            realm.delete(realm.objects(PlatformDetailObject.self))
        }
    }
}
