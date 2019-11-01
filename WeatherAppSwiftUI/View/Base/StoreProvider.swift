import WeatherAppCore
import SwiftUI

struct StoreProvider<V: View>: View, AppStoreAccessable {

  let content: () -> V
  
  var body: some View {
    content().environmentObject(store)
  }
}
