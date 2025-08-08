# Cats-Mobile-App

This is a SwiftUI app that displays cat breeds from the CAT API,
built with MVVM architecture and SwiftData persistence.
Users can search, view details and favorite breeds.

## Features

- Display list of cat breeds with images
- Search breeds by name
- Mark and view favorite breeds
- Calculate average lifespan of favorites
- Basic offline support

## Thought Process

1. Model and Inital Setup
   - Fetched raw data and defined `CatInfoModel`
   - Created `CatDataViewModel`
   - Built initial UI with (`CatDataView`)
   - Added live search filtering
   - Implemented toggle for marking breeds as favorite
2. Offilne Support
   - Migrated to SwiftData for offline storage of breeds
3. Details and favorites Screens
   - Created `DetailsView` to show breed metadata and allow toggling favorites
   - Added `FavoritesView` displaying favorite breeds and average lifespan
4. Testing Average and UI Modularization
   - Added unit tests for lifespan
   - Refactored and unified UI components for a cleaner look
5. Pagination and Architecture Refactor 
   - Implemented pagination in `CatDataService` and `CatListViewModel`
   - Merged `FavoritesViewModel` into shared `CatListViewModel`
   - Split logic into modules: `Loading`, `Cache`, and `Storage`
6. Testing and final touches
   - Added unit tests for default favorite state and toggle logic
   - Polished UI

## Folder Structure

```
CatsApp/
├── Models
│   └── CatInfoModel.swift        # @Model definition
├── Services
│   ├── Average.swift             # Average lifespan calculation
│   └── DataService.swift         # API calls
├── ViewModels
│   ├── Cache.swift
│   ├── CatDataViewModel.swift    # Business logic: fetch, search, favorites
│   ├── Loading.swift
│   └── Storage.swift
├── Views
│   ├── Components                # Reusable SwiftUI subviews
│   │   ├── AvgView.swift
│   │   ├── BreedListView.swift 
│   │   └── BreedRowView.swift
│   └── Screens                   # Full-screen composites
│       ├── CatDataView.swift
│       ├── DetailsView.swift
│       └── FavoritesViews.swift
├── CatsAppApp.swift              # App entry point and environment setup
└── CatsAppTests                  
    └── CatsAppTests.swift        # Unit tests for average calculations and favorites toggle
```


