import SwiftUI
import Combine



struct ContentView: View {
    var body: some View {
        YelpSearchView(controller: YelpSearchController())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







