playerIdByElement = {}
playerElementById = {}
playerIdByAccountName = {}
accountNameById = {}

addEvent('IDSystem.Add', true)
addEventHandler('IDSystem.Add', resourceRoot, function(accountName, player, id)
    playerIdByElement[player] = id
    playerElementById[id] = player
    playerIdByAccountName[accountName] = id
    accountNameById[id] = accountName
end)

addEvent('IDSystem.Remove', true)
addEventHandler('IDSystem.Remove', resourceRoot, function(accountName, player, id)
    playerElementById[id] = nil
    playerIdByElement[player] = nil
end)

addEvent('IDSystem.Mapping', true)
addEventHandler('IDSystem.Mapping', resourceRoot, function(playersData, accountsData)
    for player, id in pairs(playersData) do
        playerIdByElement[player] = id
        playerElementById[id] = player

        local accountName = accountsData[id]
        playerIdByAccountName[accountName] = id
        accountNameById[id] = accountName
    end
end)

addEvent('IDSystem.Change', true)
addEventHandler('IDSystem.Change', resourceRoot, function(targetPlayerID, newPlayerID)
    local targetPlayerElement, existingPlayerElement = playerElementById[targetPlayerID], playerElementById[newPlayerID]
    local targetPlayerAccountName, existingPlayerAccountName = accountNameById[targetPlayerID], accountNameById[newPlayerID]

    if targetPlayerElement then
        playerElementById[newPlayerID] = targetPlayerElement
        playerIdByElement[targetPlayerElement] = newPlayerID
        playerElementById[targetPlayerID] = nil
    end

    playerIdByAccountName[targetPlayerAccountName] = newPlayerID
    accountNameById[newPlayerID] = targetPlayerAccountName
    accountNameById[targetPlayerID] = nil

    if existingPlayerElement then
        playerElementById[targetPlayerID] = existingPlayerElement
        playerIdByElement[existingPlayerElement] = targetPlayerID
    end

    if existingPlayerAccountName then
        playerIdByAccountName[existingPlayerAccountName] = targetPlayerID
        accountNameById[targetPlayerID] = existingPlayerAccountName
    end
end)

triggerServerEvent('IDSystem.InitializeMapping', resourceRoot, localPlayer)