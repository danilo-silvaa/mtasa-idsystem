function getPlayerIdByElement (player)
    assert(isElement(player) and getElementType(player) == 'player', 'Expected element player at argument 1, got '..type(player))
    return playerIdByElement[player];
end

function getPlayerElementById (playerID)
    assert(type(tonumber(playerID)) == 'number', 'Expected number at argument 1, got ' .. type(playerID))
    return playerElementById[tonumber(playerID)];
end

function getPlayerIdByAccountName (accountName)
    assert(type(accountName) == 'string', 'Expected string at argument 1, got ' .. type(accountName))
    return playerIdByAccountName[accountName];
end

function getAccountNameById (playerID)
    assert(type(tonumber(playerID)) == 'number', 'Expected number at argument 1, got ' .. type(playerID))
    return accountNameById[tonumber(playerID)];
end