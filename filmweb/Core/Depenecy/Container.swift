//
//  Container.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

enum Container {
    static func registerDependecies() {
        Dependency.shared.register(GetMoviesUseCase.self, GetMoviesUseCaseImpl.init)
        Dependency.shared.register(SearchUseCase.self, SearchUseCaseImpl.init)
        Dependency.shared.registerSingleton(MovieListApi.self, MovieListApiService.init)
        Dependency.shared.registerSingleton(MoviesRepository.self, MoviesRepositoryImpl.init)
        Dependency.shared.registerSingleton(CoreDataService.self, CoreDataServiceImpl.init)
        Dependency.shared.register(SetAsFavoriteUseCase.self, SetAsFavoriteUseCaseImpl.init)
        Dependency.shared.register(GetFavoriteMoviesUseCase.self, GetFavoriteMoviesUseCaseImpl.init)
    }

    static func registerMockDependecies() {
        Dependency.shared.register(GetMoviesUseCase.self, GetMoviesUseCaseImpl.init)
        Dependency.shared.register(SearchUseCase.self, SearchUseCaseImpl.init)
        Dependency.shared.registerSingleton(MovieListApi.self, MovieListApiService.init)
        Dependency.shared.registerSingleton(MoviesRepository.self, MoviesRepositoryImpl.init)
        Dependency.shared.registerSingleton(CoreDataService.self, MockCoreDataService.init)
        Dependency.shared.register(SetAsFavoriteUseCase.self, SetAsFavoriteUseCaseImpl.init)
        Dependency.shared.register(GetFavoriteMoviesUseCase.self, GetFavoriteMoviesUseCaseImpl.init)
    }
}
