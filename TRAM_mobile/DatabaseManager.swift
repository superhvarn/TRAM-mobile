import SQLite3
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        if sqlite3_open("\(path)/db.sqlite3", &db) != SQLITE_OK {
            print("Unable to open database. Verify that you created the directory described in the Getting Started section.")
        } else {
            createTable()
        }
    }

    deinit {
        sqlite3_close(db)
    }

    func createTable() {
        let createTableString = """
    CREATE TABLE IF NOT EXISTS users(
    id TEXT,
    firstName TEXT,
    lastName TEXT,
    email TEXT UNIQUE,
    phoneNumber TEXT);
    """

        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Users table created.")
            } else {
                print("Users table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertUser(user: AppUser) {
        let insertStatementString = "INSERT INTO users (id, firstName, lastName, email, phoneNumber) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            // Casting the UUID as a string for the schema
            sqlite3_bind_text(insertStatement, 1, (user.id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (user.firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (user.lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (user.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (user.phoneNumber as NSString).utf8String, -1, nil)


            // Telemetry to check if database is inserting row
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                    print("Failure inserting row: \(errmsg)")
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }

        // Finalizing changes to database
        sqlite3_finalize(insertStatement)
    }

    
    func fetchUsers() -> [AppUser] {
        let queryStatementString = "SELECT id, firstName, lastName, email, phoneNumber FROM users;"
        var queryStatement: OpaquePointer?

        // Using the statement string to prepare the fetch call
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            var users = [AppUser]()

            // Iterating and fetching users
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let idString = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let phoneNumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))

                // For every component in the database, a new user with components from the previous use of the app will be added to the model
                let user = AppUser(id: idString, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
                users.append(user)
            }

            sqlite3_finalize(queryStatement)
            return users
        } else {
            print("SELECT statement could not be prepared")
            return []
        }
    }
    
    func updateUser(_ user: AppUser) {
        let updateStatementString = "UPDATE users SET firstName = ?, lastName = ?, email = ?, phoneNumber = ? WHERE id = ?;"

        var updateStatement: OpaquePointer?

        // Using the statement string to prepare the update
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            // Casting everything as text for SQL and putting id as last for key purposes
            sqlite3_bind_text(updateStatement, 1, (user.firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (user.lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (user.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (user.phoneNumber as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (user.id as NSString).utf8String, -1, nil)

            // Telemetry to check if update successful
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }

        // Solidfying changes to database
        sqlite3_finalize(updateStatement)
    }
    
    func deleteUser(_ user: AppUser) {
        let deleteStatementString = "DELETE FROM users WHERE id = ?;"

        var deleteStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (user.id as NSString).utf8String, -1, nil)

            if sqlite3_step(deleteStatement) != SQLITE_DONE {
                print("Error deleting row: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }

        sqlite3_finalize(deleteStatement)
    }
    
    func deleteAllUsers() {
        let deleteAllString = "DELETE FROM users;"

        var deleteAllStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteAllString, -1, &deleteAllStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteAllStatement) == SQLITE_DONE {
                print("All users deleted.")
            } else {
                print("Could not delete users.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteAllStatement)
    }
}

