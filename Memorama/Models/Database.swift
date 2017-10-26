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

// Record model
class Record: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var nombre = ""
    @objc dynamic var ticket = ""
    @objc dynamic var monto = ""
    @objc dynamic var email = ""
    @objc dynamic var gano = ""
    @objc dynamic var premio = ""
    @objc dynamic var fecha = ""
    @objc dynamic var tienda = ""
    @objc dynamic var correo_enviado = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

// Register struct
struct Register {
    var name = ""
    var ticket = ""
    var amount = ""
    var email = ""
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
    
    var pendingRecords: (Results<Record>)? {
        if let realm = realm {
            return realm.objects(Record.self).filter("correo_enviado = 'no'")
        } else {
            return nil
        }
    }
    
    var sentRecords: (Results<Record>)? {
        if let realm = realm {
            return realm.objects(Record.self).filter("correo_enviado = 'si'")
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
    
    func saveGameWith(register: Register, price: Prize, completion: (Record?)->()) {
        if let realm = realm {
            let record = Record()
            record.nombre = register.name
            record.ticket = register.ticket
            record.monto = register.amount
            record.email = register.email
            switch price {
            case .None:
                record.gano = "no"
            case .Sneakers:
                record.gano = "si"
                record.premio = "tenis"
            case .Textile:
                record.gano = "si"
                record.premio = "textil"
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            record.fecha = formatter.string(from: Date())
            record.tienda = store
            record.correo_enviado = "no"
            
            try! realm.write {
                realm.add(record)
            }            
            completion(record)
        } else {
            completion(nil)
        }
        
    }
}
