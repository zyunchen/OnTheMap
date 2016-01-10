//
//  OnTheMapConstants.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/12/3.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

extension OnTheMapClient {
    
    
    // MARK: Constants
    struct Constants {
        
        
        static let BaseUrl = "https://www.udacity.com/api/"
        static let ParseBaseUrl = "https://api.parse.com/1/classes/"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        static let GetSession = "session"
        static let GetStudentLocation = "StudentLocation?order=-updatedAt"
        
        // MARK: Account
        static let Account = "account"
        static let AccountIDFavoriteMovies = "account/{id}/favorite/movies"
        static let AccountIDFavorite = "account/{id}/favorite"
        static let AccountIDWatchlistMovies = "account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "account/{id}/watchlist"
        
        // MARK: Authentication
        static let AuthenticationTokenNew = "authentication/token/new"
        static let AuthenticationSessionNew = "authentication/session/new"
        
        // MARK: Search
        static let SearchMovie = "search/movie"
        
        // MARK: Config
        static let Config = "configuration"
        
    }
    
    struct Server {
        static let UDACITY = 1
        static let PARSE = 2
    }


}