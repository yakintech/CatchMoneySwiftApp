import SwiftUI
import Alamofire

struct AddExpense: View {
    @State private var amount: String = ""
    // State variable to hold the categories and selected category
    @State var categories: [CategoryPickerModel] = []
    @State private var selectedCategory = CategoryPickerModel()
    
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Choose desired date style (e.g., .medium, .short, .long)
        return formatter.string(from: Date())
    }// Set an initial default category
    
    var body: some View {
        VStack(spacing :10) {
            if categories.isEmpty {
                // Show a loading message if categories are not loaded yet
                Text("Loading categories...")
                    .padding()
            } else {
                HStack{
                    Text("Selected Category: ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Picker("Please choose a category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            
                            Text(category.name)
                            .tag(category)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .pickerStyle(MenuPickerStyle()) // Change to MenuPickerStyle for a dropdown picker
                }.padding(.horizontal)
            }
            HStack{
                Text("Enter Amount: ")
                TextField("Amount", text: $amount)
                .keyboardType(.decimalPad) // Use decimal pad for numeric input
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Style the TextField
                .padding(.horizontal)
            }.padding(.horizontal)
            Text("Date: \(currentDate)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            Button(action: {
                print("Add Button Clikec")
            }) {
                Text("Add")
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.padding()
                
            
            
            
            
            Spacer()
            
        }
        .onAppear {
            fetchCategories()
        }
    }
    
    // Function to fetch categories using Alamofire
    func fetchCategories() {
        let url = "https://walrus-app-hqcca.ondigitalocean.app/category"
        
        AF.request(url, method: .get).responseDecodable(of: [CategoryPickerModel].self) { response in
            switch response.result {
            case .success(let fetchedCategories):
                // Only update categories if API call succeeds and contains data
                if !fetchedCategories.isEmpty {
                    categories = fetchedCategories
                    selectedCategory = categories.first ?? CategoryPickerModel() // Set the first category as the default selected
                }
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }
}

#Preview {
    AddExpense()
}
