import SwiftUI
import Alamofire

struct AddExpense: View {
    @State private var amount: String = ""
    // State variable to hold the categories and selected category
    @State var categories: [CategoryPickerModel] = []
    @State private var selectedCategory = CategoryPickerModel()
    
    @State private var currentDate = Date()
    
    var body: some View {
        VStack(spacing :10) {
            if categories.isEmpty {
                // Show a loading message if categories are not loaded yet
                Text("Loading categories...")
                    .padding()
            } else {
                HStack{
                    Text("Selected Category: ")
                        .frame( alignment: .leading)
                    Picker("Please choose a category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            
                            Text(category.name)
                            .tag(category)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .pickerStyle(MenuPickerStyle())
                }.padding(.horizontal)
            }
            HStack {
                Text("Enter Amount: ")
                    .frame(alignment: .leading)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Style the TextField
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            
            VStack(alignment: .leading) {
                Text("Select a date")
                    .font(.headline)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .center)

                DatePicker("", selection: $currentDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
            }
            .padding()

            Text("Date: \(currentDate, formatter: dateFormatter)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Button(action: {
                print("Add Button Clicked")
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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // You can adjust the style here
        return formatter
    }
    
    
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
