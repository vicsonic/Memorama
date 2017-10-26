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
class Record: Object, CSVExporting {
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
    
    // MARK: - Primary Key
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - CSVExporting
    
    static func templateString() -> String {        
        return "id, nombre, ticket, monto, email, gano, premio, fecha, tienda\n"
    }
    
    func exportAsCommaSeparatedString() -> String {
        return "\(self.id), \(self.nombre), \(self.ticket), \(self.monto), \(self.email), \(self.gano), \(self.premio), \(self.fecha), \(self.tienda)\n"
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
            formatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
            
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
    
    func deleteRecords(_ records: Results<Record>) {
        if let realm = realm {
            try! realm.write {
                realm.delete(records)
            }
            realm.refresh()
        }
    }
    
    func markRecordsAsSent(_ records: Results<Record>) {
        if let realm = realm {
            try! realm.write {
                for record in records {
                    record.correo_enviado = "si"
                }
            }
            realm.refresh()
        }
    }
}

extension FileManager {
    
    class func prepareCSVFileForRecords(completion: ((Data?)->())? ) {
        let documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        guard let path = documents.first else { return }
        let filePath = String(NSString(string:path).appendingPathComponent("Records.csv"))
        guard let url = URL(string: filePath) else { return }
        guard let records = Database.shared.pendingRecords else { return }
        let items = Array(records)
        let operation = CSVOperation(filePath: url, source: items)
        operation.completionBlock = {
            if operation.finishedState == .success {
                if let fileHandle = FileHandle(forReadingAtPath: filePath) {
                    let data = fileHandle.readDataToEndOfFile()
                    completion?(data)
                } else {
                    completion?(nil)
                }
            } else {
                completion?(nil)
            }
        }
        OperationQueue.main.addOperation(operation)
    }
    
}
