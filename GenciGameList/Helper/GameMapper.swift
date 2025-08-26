//
//  GameMapper.swift
//  GenciGameList
//
//  Created by naswakhansa on 26/08/25.
//

import Foundation

enum GameMapper {
    static func toRealm(_ dto: GameDetailResponseModel) -> GameDetailObject {
        let obj = GameDetailObject()
        obj.id = dto.id
        obj.name = dto.name
        obj.gameDescription = dto.description
        obj.metacritic = dto.metacritic
        obj.backgroundImage = dto.backgroundImage
        obj.rating = dto.rating
        obj.released = dto.released

        obj.developers.removeAll()
        dto.developers?.forEach {
            let d = DeveloperObject()
            d.id = $0.id; d.name = $0.name
            obj.developers.append(d)
        }

        obj.genres.removeAll()
        dto.genres?.forEach {
            let g = DeveloperObject()
            g.id = $0.id; g.name = $0.name
            obj.genres.append(g)
        }

        obj.platforms.removeAll()
        dto.platforms?.forEach {
            let p = PlatformObject()
            let pd = PlatformDetailObject()
            pd.id = $0.platform.id; pd.name = $0.platform.name
            p.platform = pd
            obj.platforms.append(p)
        }

        return obj
    }

    static func fromRealm(_ obj: GameDetailObject) -> GameDetailResponseModel {
        GameDetailResponseModel(
            id: obj.id,
            name: obj.name,
            description: obj.gameDescription,
            metacritic: obj.metacritic,
            backgroundImage: obj.backgroundImage,
            platforms: obj.platforms.map {
                Platforms(platform: PlatformDetail(id: $0.platform?.id ?? 0,
                                                   name: $0.platform?.name ?? ""))
            },
            genres: obj.genres.map { Developers(id: $0.id, name: $0.name) },
            developers: obj.developers.map { Developers(id: $0.id, name: $0.name) },
            rating: obj.rating,
            released: obj.released
        )
    }
}
