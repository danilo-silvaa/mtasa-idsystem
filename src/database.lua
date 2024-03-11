Database = {}

local dbConnection

function Database.connect()
    dbConnection = dbConnect('sqlite', 'database/database.db')
    if dbConnection then
        outputDebugString('[ID_System - DataBase]: Conectado ao banco de dados.')
    else
        outputDebugString('[ID_System - DataBase]: Falha ao conectar ao banco de dados!', 1)
    end
end

function Database.query(...)
    if dbConnection then
        return dbQuery(dbConnection, ...)
    end
    return false
end

function Database.execute(...)
    if dbConnection then
        return dbExec(dbConnection, ...)
    end
    return false
end

function Database.fetch(queryHandle)
    if queryHandle then
        return dbPoll(queryHandle, -1)
    end
    return false
end

function Database.getDBConnection()
    return dbConnection
end

Database.connect()