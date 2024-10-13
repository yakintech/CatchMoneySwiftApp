import SwiftUI
import Alamofire
import UIKit

/*struct ExpenseRequest: Codable {
    let amount: Double
    let date: String
    let category: String
    let description: String
    let images: [Data]
}*/

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?

        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct AddExpense: View {
    @State private var amount: String = ""
    @State private var description : String = ""
    // Image picker variables
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var imagePickedSuccess = false
    // State variable to hold the categories and selected category
    @State var categories: [Category] = []
    @State private var selectedCategory = Category()
    
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                    .onChange(of: amount) { newValue in
                        let filtered = newValue.filter { $0.isNumber || $0 == "." }
                            let decimalCount = filtered.filter { $0 == "." }.count
                                        
                    
                            if decimalCount <= 1 {
                                if filtered == "." {
                                    amount = "0."
                                } else {
                                    amount = filtered
                                }
                            } else {
                                amount = String(filtered.dropLast())
                                
                            }
                    }
            }.padding(.horizontal)
            HStack {
                Text("Description: ")
                    .frame(alignment: .leading)
                TextEditor(text: $description)
                    .frame(maxWidth: .infinity,minHeight: 50,maxHeight: 100) // Set a minimum height for the TextEditor
                    .border(Color.gray, width: 1) // Optional: Add a border for better visibility
                    .padding(3)
            }
            .padding(.horizontal)
            
            VStack {
                HStack{
                    Button(action: {
                        showingImagePicker = true
                    }){Text("Pick an Image")
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 80, maxHeight: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    
                }
                .padding(.horizontal)
                if imagePickedSuccess {
                    Text("Image picked successfully!")
                        .foregroundColor(.green)
                        .padding(2)
                        .font(.system(size: 12))
                }else{
                    Text("There is no image picked")
                        .foregroundColor(.red)
                        .padding(2)
                        .font(.system(size: 12))
                }

            }.sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if selectedImage != nil {
                        imagePickedSuccess = true
                    }
                }
            }
            VStack(alignment: .leading) {
                DatePicker("", selection: $currentDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
            }
            .padding()

            Text("Selected Date: \(currentDate, formatter: dateFormatter)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Button(action: {
                
                if let amountValue = Double(amount) {
                    let dateString = dateFormatter.string(from: currentDate)
                    addExpense(amount: amountValue, date: dateString, category: selectedCategory.name)
                } else {
                    print("Invalid amount entered")
                }
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
        formatter.dateFormat = "dd,MM,yyyy" // Set the desired format
        return formatter
    }
    
    func fetchCategories() {
        let url = "https://walrus-app-hqcca.ondigitalocean.app/category"
        
        AF.request(url, method: .get).responseDecodable(of: [Category].self) { response in
            switch response.result {
            case .success(let fetchedCategories):
                // Only update categories if API call succeeds and contains data
                if !fetchedCategories.isEmpty {
                    categories = fetchedCategories
                    selectedCategory = categories.first ?? Category() // Set the first category as the default selected
                }
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }
    
    func addExpense(amount: Double, date: String, category: String) {
        // Prepare the image data array
        let imageDataArray: [Data]
        
        if let selectedImage = selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
            imageDataArray = [imageData] // If an image is selected, create an array with its data
        } else {
            imageDataArray = [] // Send an empty array if no image is selected
        }
        
        // Prepare your expense request
        let expenseRequest = AddExpenseModel(
            amount: amount,
            description: description,
            date: date,
            category: selectedCategory, // You can add a description if needed
            images: imageDataArray // Include images here
        )

        // Define the URL for the API endpoint
        let url = "\(APIConfig.apiUrl)/addexpense"

        // Use Alamofire to upload the data
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(amount)".data(using: .utf8)!, withName: "amount")
            multipartFormData.append(date.data(using: .utf8)!, withName: "date")
            multipartFormData.append(category.data(using: .utf8)!, withName: "category")
            multipartFormData.append(description.data(using: .utf8)!, withName: "description")
            
            // Upload images if selected
            if let selectedImage = selectedImage,
               let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "images", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        }, to: "\(APIConfig.apiUrl)/Addexpense", method: .post)
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                print("Expense added successfully: \(data)")
            case .failure(let error):
                print("Failed to add expense: \(error.localizedDescription)")
            }
        }

    }

}

#Preview {
    AddExpense()
}
