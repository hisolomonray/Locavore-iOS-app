import SwiftUI
import MapKit




struct YelpSearchView: View {
    @ObservedObject var controller: YelpSearchController
    @State private var selectedBusiness: Business?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Locavore")
                        .font(.largeTitle.bold())
                        .padding(.top)
                        .foregroundColor(.white)
                    
                    HStack {
                        Spacer()
                        TextField("Search term", text: $controller.searchTerm)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .frame(height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        
                            .padding(.leading, -8)
                            .font(.subheadline)
                            .foregroundColor(.white) // Set the font color to white
                            .onSubmit {
                                controller.performSearch()
                            }
                            .overlay(
                                HStack {
                                    Spacer()
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.white)
                                        .padding(.trailing, 8)
                                }
                            )
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Spacer()
                        TextField("Location", text: $controller.location)
                            .padding(.horizontal, 10)
                            .frame(height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .padding(.leading, -8)
                            .font(.subheadline)
                            .foregroundColor(.white) // Set the font color to white
                            .onSubmit {
                                controller.performSearch()
                            }
                            .overlay(
                                HStack {
                                    Spacer()
                                    Image(systemName: "location")
                                        .foregroundColor(.white)
                                        .padding(.trailing, 8)
                                }
                            )
                    }
                    
                    Button(action: {
                        print("Performing search...")
                        controller.performSearch()
                    }) {
                        Text("Search")
                            .padding(.horizontal)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white) // Set the font color to white
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .background(Color.black) // Set the background color to black
                    
                    VStack(alignment: .leading) {
                        ForEach(controller.businesses, id: \.id) { business in
                            NavigationLink(destination: BusinessDetailView(business: business, imageUrl: business.imageUrl)) {
                                VStack {
                                    BusinessRowView(business: business, selectedBusiness: $selectedBusiness)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                        .background(Color.black) // Set the background color to black
                                        .cornerRadius(10)
                                    
                                    Divider()
                                        .padding(.horizontal)
                                        .background(Color.white.opacity(0.5)) // Set the divider color to white
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom)
            .padding(.horizontal)
            .background(Color.black) // Set the background color to black
            .ignoresSafeArea()
            
        }
    }
}

struct BusinessRowView: View {
    var business: Business
    @Binding var selectedBusiness: Business?
    
    @StateObject private var imageLoader: ImageLoader = ImageLoader()
    @State private var showingMap = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageUrl = business.imageUrl, let url = URL(string: imageUrl) {
                AsyncImageLoaderView(imageURL: url, imageLoader: imageLoader)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .onAppear {
                        imageLoader.loadImage(from: url)
                    }
                    .onDisappear {
                        imageLoader.cancel()
                        print("Image loading canceled")
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(business.name)
                    .font(.headline)
                    .underline()
                    .foregroundColor(.white) // Set the font color to white
                
                YelpStarRatingView(rating: business.rating)
                    .font(.subheadline)
                    .foregroundColor(.white) // Set the font color to white
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Price: \(business.price ?? "-")")
                        .font(.subheadline)
                        .foregroundColor(.white) // Set the font color to white
                    
                    Text("Phone: \(business.phone)")
                        .font(.subheadline)
                        .foregroundColor(.white) // Set the font color to white
                    
                    Text("\(business.location.address1), \(business.location.placemark?.locality ?? ""), \(business.location.placemark?.administrativeArea ?? "") \(business.location.placemark?.postalCode ?? "")")
                        .font(.subheadline)
                        .lineLimit(nil)
                        .foregroundColor(.white) // Set the font color to white
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.trailing)
        .background(Color.black) // Set the background color to black
        .cornerRadius(10)
    }
}
