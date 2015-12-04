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
        
        
        static let baseUrl = "https://www.udacity.com/api/"
        
        // MARK: URLs
        static let BaseURL : String = "http://api.themoviedb.org/3/"
        static let BaseURLSecure : String = "https://api.themoviedb.org/3/"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        static let GetSession = "session"
        
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


}