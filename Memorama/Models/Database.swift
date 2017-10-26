//
//  Database.swift
//  Memorama
//
//  Created by Victor Soto on 10/25/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// Game model
class Juego: Object {
    @objc dynamic var nombre = ""
    @objc dynamic var ticket = ""
    @objc dynamic var monto = ""
    @objc dynamic var email = ""
    @objc dynamic var gano = ""
    @objc dynamic var premio = ""
    @objc dynamic var fecha = ""
    @objc dynamic var sucursal = ""
    @objc dynamic var correo_enviado = ""
}

// Store model
class Tienda: Object {
    @objc dynamic var nombre = ""
}

class Database {
    
    static let stores = ["Galerías Monterrey",
                         "Galerías Guadalajara",
                         "Plaza las Américas Jalapa",
                         "Angelopolis Puebla",
                         "Plaza Q Pachuca",
                         "Satelite",
                         "Nezahualcoyotl",
                         "Lindavista",
                         "Querétaro Plaza",
                         "Parque Tezontle"]
    
    static let shared = Database()
    private var realm: Realm? = nil
    
    func start() {
        do {
            self.realm = try Realm()
        } catch {
            self.realm = nil
        }
    }
    
    var pendingRecords: (Results<Juego>)? {
        if let realm = realm {
            return realm.objects(Juego.self).filter("correo_enviado = 'no'")
        } else {
            return nil
        }
    }
    
    var sentRecords: (Results<Juego>)? {
        if let realm = realm {
            return realm.objects(Juego.self).filter("correo_enviado = 'si'")
        } else {
            return nil
        }
    }
    
    var store: String {
        get {
            if let value = UserDefaults.standard.string(forKey: "store") {
                return value
            }
            return ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "store")
        }
    }
}
