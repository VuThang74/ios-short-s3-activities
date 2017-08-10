import MySQL

// MARK: - MySQLDataAccessor

class MySQLDataAccessor {

    // MARK: Properties

    let connection: MySQLConnectionProtocol

    let selectActivities = MySQLQueryBuilder()
            .select(fields: ["id", "name", "emoji", "description", "genre",
            "min_participants", "max_participants", "created_at", "updated_at"], table: "activities")

    // MARK: Initializer

    init(connection: MySQLConnectionProtocol) {
        self.connection = connection
    }

    // MARK: Queries

    func createActivity(_ activity: Activity) throws -> Bool {
        let insertQuery = MySQLQueryBuilder()
                .insert(data: activity.toMySQLRow(), table: "activities")

        let result = try connection.execute(builder: insertQuery)

        if result.affectedRows < 1 {
            return false
        }

        return true
    }

    func updateActivity(_ activity: Activity) throws -> Bool {
        let updateQuery = MySQLQueryBuilder()
                .update(data: activity.toMySQLRow(), table: "activities")
                .wheres(statement: "WHERE Id=?", parameters: "\(activity.id!)")

        let result = try connection.execute(builder: updateQuery)

        if result.affectedRows < 1 {
            return false
        }

        return true
    }

    func deleteActivity(withID id: String) throws -> Bool {
        let deleteQuery = MySQLQueryBuilder()
                .delete(fromTable: "activities")
                .wheres(statement: "WHERE Id=?", parameters: "\(id)")

        let result = try connection.execute(builder: deleteQuery)
        
        if result.affectedRows < 1 {
            return false
        }

        return true
    }

    func getActivities(withID id: String) throws -> [Activity]? {
        let select = selectActivities.wheres(statement:"WHERE Id=?", parameters: id)

        let result = try connection.execute(builder: select)
        let activities = result.toActivities()

        if activities.count == 0 {
            return nil
        }

        return activities
    }

    func getActivities() throws -> [Activity]? {
        let result = try connection.execute(builder: selectActivities)
        
        let activities = result.toActivities()

        if activities.count == 0 {
            return nil
        }

        return activities
    }
}
