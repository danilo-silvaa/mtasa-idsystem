Accounts = {}

local success = Database.execute([[
    CREATE TABLE IF NOT EXISTS account_ids (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_name TEXT NOT NULL
    )
]])

if success then
    outputDebugString('[ID_System - Accounts]: Tabela account_ids criada com sucesso.')
else
    outputDebugString('[ID_System - Accounts]: Falha ao criar a tabela account_ids!', 1)
end

function Accounts.register(accountName)
    local queryHandle = Database.query('INSERT INTO account_ids (account_name) VALUES (?)', accountName)
    local success, _, lastInsertID = Database.fetch(queryHandle)
    return success and lastInsertID or nil
end

function Accounts.fetchAll()
    local queryHandle = Database.query('SELECT * FROM account_ids')
    return Database.fetch(queryHandle)
end

function Accounts.changeID(targetPlayerID, newPlayerID)
    local queryHandle = Database.query('SELECT id FROM account_ids WHERE id = ?', newPlayerID)
    local result = Database.fetch(queryHandle)

    if result and #result > 0 then
        local tempID = -1
        Database.execute('UPDATE account_ids SET id = ? WHERE id = ?', tempID, newPlayerID)
        Database.execute('UPDATE account_ids SET id = ? WHERE id = ?', newPlayerID, targetPlayerID)
        Database.execute('UPDATE account_ids SET id = ? WHERE id = ?', targetPlayerID, tempID)
    else
        Database.execute('UPDATE account_ids SET id = ? WHERE id = ?', newPlayerID, targetPlayerID)
    end

    return true
end