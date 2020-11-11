//
//  ScanKTPView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct ScanKTPView: View {
    
    /*
     Recognized Nomor Induk Ktp
     */
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    @State var imageKTP: Image? = nil
    @State var nik: String = ""
    @State var isEditNik: Bool = false
    
    let formIndex: Int
    let callback: (Int)->()
    
    /*
     Fungsi untuk Toggle CheckBox NIK
     */
    func toggleEditNik() {
        isEditNik = !isEditNik
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("")
            Text("Mohon siapkan terlebih dahulu \nKartu Tanda Penduduk (KTP) Anda")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Regular", size: 12))
                .padding(.vertical, 15)
            
            ZStack {
                Image("ic_camera")
                VStack {
                    imageKTP?
                        .resizable()
                        .frame(maxWidth: 350, maxHeight: 200)
                        .cornerRadius(10)
                }
                .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 200, maxHeight: 221)
            }
            .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 200, maxHeight: 221)
            .background(Color(hex: "#F5F5F5"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color(.gray).opacity(0.2))
            )
            
            NavigationLink(destination: ScanningView(recognizedText: $recognizedText.value)) {
                
                Text(imageKTP == nil ? "Ambil Foto KTP" : "Ganti Foto Lain")
                    .foregroundColor(imageKTP == nil ? .white : Color(hex: "#2334D0"))
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color(.gray).opacity(0.4))
                    )
                
            }
            .background(Color(hex: imageKTP == nil ? "#2334D0" : "#FFFFFF"))
            .cornerRadius(12)
            //            .padding(.horizontal, 30)
            .padding([.top, .bottom], 15)
            
            VStack(alignment: .leading) {
                
                Text("Nomor Kartu Tanda Penduduk")
                    .multilineTextAlignment(.leading)
                    .font(.custom("Montserrat-SemiBold", size: 10))
                //                    .padding(.horizontal, 30)
                
                TextField("No. KTP (Otomatis terisi)", text: $nik)
                    .frame(height: 10)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    //                    .padding(.horizontal, 30)
                    .disabled(!isEditNik)
                
                Button(action: toggleEditNik) {
                    HStack(alignment: .top) {
                        Image(systemName: isEditNik ? "checkmark.square": "square")
                        Text("* Periksa kembali dan pastikan Nomor Kartu Tanda Penduduk (KTP) Anda telah sesuai")
                            .font(.custom("Montserrat-Regular", size: 8))
                            .foregroundColor(Color(hex: "#707070"))
                    }
                    //                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                if (imageKTP != nil) {
                    
                    Button(action: {
                        callback(formIndex+1)
                    }) {
                        Text("Simpan")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 30)
                    
                } else { EmptyView() }
                
            }
        }
        .padding(.bottom, 15)
        .onAppear {
            print(recognizedText.value)
            
            if (recognizedText.value != "-") {
                print("scan value : \(recognizedText.value)")
                let matched = matches(for: "(\\d{13,16})", in: recognizedText.value)
                print(matched)
                
                if matched.count != 0 {
                    self.nik = matched[0]
                    _ = retrieveImage(forKey: "ktp")
                }
                
            }
        }
    }
    
    /*
     Fungsi untuk ambil Gambar dari Local Storage
     */
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
           let image = UIImage(data: imageData) {
            print(image)
            
            imageKTP = Image(uiImage: image)
            return image
        }
        
        return nil
    }
    
    /*
     Fungsi Regex NIK
     */
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

struct ScanKTPView_Previews: PreviewProvider {
    static var previews: some View {
        ScanKTPView(formIndex: 1) { (nextFormIndex) in
            
        }
    }
}
