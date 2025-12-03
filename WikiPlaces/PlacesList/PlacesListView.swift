import SwiftUI

@MainActor
@Observable
final class PlacesListViewModel: PlacesListDisplaying {
    enum LoadingState {
        case idle
        case loading
        case error
    }

    var loadingState: LoadingState = .idle

    struct PlacesDataStore {
        var remotePlaces: [PlacesList.Place] = []
        var localPlaces: [PlacesList.Place] = []
    }

    var placesDataStore = PlacesDataStore()

    var errorMessage: String?

    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""

    func displayPlaces(viewModel: PlacesList.LoadPlaces.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            loadingState = .error
            self.errorMessage = errorMessage
            return
        }

        loadingState = .idle
        placesDataStore.remotePlaces = viewModel.places
    }

    func displayInvalidDeepLink(viewModel: PlacesList.PrepareDeepLink.ViewModel) {
        showAlert = true
        alertTitle = viewModel.errorTitle
        alertMessage = viewModel.errorMessage
    }
}

struct PlacesListView: View {
    let interactor: PlacesListInteracting
    @State var viewModel: PlacesListViewModel
    @State private var showCustomPlaceInputSheet = false

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        switch viewModel.loadingState {
                        case .loading:
                            ProgressView()
                        case .idle:
                            remotePlaces
                            customPlaces
                        case .error:
                            errorView
                        }
                    }.padding(16)
                }.onChange(of: viewModel.placesDataStore.localPlaces) { _, _ in
                    scrollViewProxy.scrollTo("customPlacesTitle", anchor: .top)
                }
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCustomPlaceInputSheet = true
                    }, label: {
                        Text("Add custom place")
                    })
                }
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $showCustomPlaceInputSheet) {
            CustomPlaceInputSheet(coordinateValidator: CoordinateValidator()) { name, latitude, longitude in
                let place = PlacesList.Place(
                    name: name.isEmpty ? "Unnamed place" : name,
                    latitude: latitude,
                    longitude: longitude)

                viewModel.placesDataStore.localPlaces.insert(place, at: 0)
            }
        }
        .task {
            viewModel.loadingState = .loading
            await interactor.loadPlaces(request: .init())
        }
    }

    @ViewBuilder
    private var errorView: some View {
        if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 24) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .font(.largeTitle)

                Text(errorMessage)
                    .font(.headline)
                    .foregroundStyle(.black)

                Button("Retry") {
                    Task {
                        viewModel.loadingState = .loading
                        await interactor.loadPlaces(request: .init())
                    }
                }
            }
            .padding(32)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 1)
            )
        }
    }

    private var remotePlaces: some View {
        ForEach(viewModel.placesDataStore.remotePlaces) { place in
            PlaceView(
                placeName: place.name,
                latitude: place.latitude,
                longitude: place.longitude
            ).onTapGesture {
                interactor.prepareDeepLink(
                    request: .init(
                        name: place.name,
                        latitude: place.latitude,
                        longitude: place.longitude))
            }
        }
    }

    @ViewBuilder
    private var customPlaces: some View {
        if !viewModel.placesDataStore.localPlaces.isEmpty {
            Text("Custom places")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .id("customPlacesTitle")
                .accessibilityAddTraits(.isHeader)
                .accessibilityValue("Custom places")
                .accessibilityHint("Customly added places are listed from here onwards")

            ForEach(viewModel.placesDataStore.localPlaces) { place in
                PlaceView(
                    placeName: place.name,
                    latitude: place.latitude,
                    longitude: place.longitude
                ).onTapGesture {
                    interactor.prepareDeepLink(
                        request: .init(
                            name: place.name,
                            latitude: place.latitude,
                            longitude: place.longitude))
                }
            }
        }
    }
}
