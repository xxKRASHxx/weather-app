import SwiftUI

struct SearchView: View {
  
  @Binding var searchText: String
  @Binding var isActive: Bool
  
  var body: some View {
    HStack {
      HStack {
        Image(systemName: "magnifyingglass")
        
        TextField(
          "search",
          text: $searchText,
          onEditingChanged: { isEditing in self.isActive = isEditing }
        ).foregroundColor(.primary)
        
        Button(action: { self.searchText = "" }) {
          Image(systemName: "xmark.circle.fill")
            .opacity(searchText == "" ? 0 : 1)
        }
      }
      .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
      .foregroundColor(.secondary)
      .background(Color(.secondarySystemBackground))
      .cornerRadius(10.0)
      
      if isActive {
        Button("Cancel") {
          UIApplication.shared.endEditing(true)
          self.searchText = ""
          self.isActive = false
        }
        .foregroundColor(Color(.systemBlue))
        .animation(.default)
      }
    }
    .padding(.horizontal)
    .navigationBarHidden(isActive)
    .animation(.default)
  }
}

struct SearchView_Previews: PreviewProvider {
  
  @State static private var searchText: String = ""
  @State static private var isSearchActive: Bool = false
  
  static var previews: some View {
    SearchView(
      searchText: $searchText,
      isActive: $isSearchActive
    )
  }
}
