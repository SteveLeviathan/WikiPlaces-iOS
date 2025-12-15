import SwiftUI

struct PlacesListView: View {
    let interactor: PlacesListInteracting
    @State var presenter: PlacesListPresenter
    @State private var showCustomPlaceInputSheet = false

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        switch presenter.loadingState {
                        case .loading:
                            ProgressView()
                        case .idle:
                            remotePlaces
                            customPlaces
                        case .error:
                            errorView
                        }
                    }.padding(16)
                }.onChange(of: presenter.placesDataStore.localPlaces) { _, _ in
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
        .alert(presenter.alertTitle, isPresented: $presenter.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(presenter.alertMessage)
        }
        .sheet(isPresented: $showCustomPlaceInputSheet) {
            CustomPlaceInputSheet(coordinateValidator: CoordinateValidator()) { name, latitude, longitude in
                let place = PlacesList.Place(
                    name: name.isEmpty ? "Unnamed place" : name,
                    latitude: latitude,
                    longitude: longitude)

                presenter.placesDataStore.localPlaces.insert(place, at: 0)
            }
        }
        .task {
            presenter.loadingState = .loading
            await interactor.loadPlaces(request: .init())
        }
    }

    @ViewBuilder
    private var errorView: some View {
        if let errorMessage = presenter.errorMessage {
            VStack(spacing: 24) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .font(.largeTitle)

                Text(errorMessage)
                    .font(.headline)
                    .foregroundStyle(.black)

                Button("Retry") {
                    Task {
                        presenter.loadingState = .loading
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
        ForEach(presenter.placesDataStore.remotePlaces) { place in
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
        if !presenter.placesDataStore.localPlaces.isEmpty {
            Text("Custom places")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .id("customPlacesTitle")
                .accessibilityAddTraits(.isHeader)
                .accessibilityValue("Custom places")
                .accessibilityHint("Customly added places are listed from here onwards")

            ForEach(presenter.placesDataStore.localPlaces) { place in
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
