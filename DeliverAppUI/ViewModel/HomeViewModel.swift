//
//  HomeViewModel.swift
//  DeliverAppUI
//
//  Created by PedroJSMK on 05/10/21.
//

import SwiftUI
import CoreLocation
import Firebase

// Localizacao
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    @Published var noLocation = false
    
    
    // localizacao e detalhes
    @Published var userLocation : CLLocation!
    @Published var userAdress = ""
    
    // menu
    @Published var showMenu = false
    
    // items data
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []

    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // verifica localizacao
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Autorizado")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("Negado")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false

            // direciona
            locationManager.requestWhenInUseAuthorization()

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // localizacao e detalhes
        self.userLocation = locations.last
        self.extratLocation()
        // extrai localizacao apos login
        self.login()
    }
    
    func extratLocation() {
        
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
            
            guard let safeData = res else {return}
            
            var address = ""
            
            // get area and localidade name...
            
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAdress = address
            
        }
        
    }
    // DB firebase
    func login(){
        Auth.auth().signInAnonymously { (res, err) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            print("Sucesso = \(res!.user.uid)")
            
            self.fecthData()
        }
    }
    
    // items data
    
    func fecthData() {
        let db = Firestore.firestore()
        
        db.collection("Items").getDocuments {(snap, err) in
            guard let itemData = snap else{return}
            
            self.items = itemData.documents.compactMap({(doc) -> Item? in
                
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let ratings = doc.get("item_ratings") as! String
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
           
            return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            })
            self.filtered = self.items
        }
    }
    
    // filtro busca
    func filterData() {
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
}
