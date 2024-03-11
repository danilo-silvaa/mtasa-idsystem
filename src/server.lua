playerIdByElement = {}
playerElementById = {}
playerIdByAccountName = {}
accountNameById = {}

local rows = Accounts.fetchAll()
if rows then
    for _, row in pairs(rows) do
        local accountName = row.account_name
        local account = getAccount(accountName)

        if account then
            local player = getAccountPlayer(account)

            if player then
                playerIdByElement[player] = row.id
                playerElementById[row.id] = player
            end
        end

        accountNameById[row.id] = accountName
        playerIdByAccountName[accountName] = row.id
    end
end

addEventHandler('onPlayerLogin', root, function(_, account)
    local accountName = getAccountName(account)
    local id = playerIdByAccountName[accountName] or Accounts.register(accountName)

    if id then
        playerIdByElement[source] = id
        playerElementById[id] = source
        playerIdByAccountName[accountName] = id
        accountNameById[id] = accountName
        triggerClientEvent('IDSystem.Add', resourceRoot, accountName, source, id)
    end
end)

addEventHandler('onPlayerQuit', root, function()
    local id = playerIdByElement[source]

    if id then
        playerElementById[id] = nil
        playerIdByElement[source] = nil
        triggerClientEvent('IDSystem.Remove', resourceRoot, source, id)
    end
end)

addCommandHandler(config.changeIDCommand, function(player, _, targetPlayerID, newPlayerID)
    if not hasPermission(player) then
        return outputChatBox('Você não tem permissão para executar esse comando.', player, 255, 0, 0)
    end

    targetPlayerID, newPlayerID = tonumber(targetPlayerID), tonumber(newPlayerID)

    if not (targetPlayerID and newPlayerID) then
        return outputChatBox('Uso correto: /' .. config.changeIDCommand .. ' idAlvo novoID', player, 255, 165, 0)
    end

    if (Accounts.changeID(targetPlayerID, newPlayerID)) then
        local targetPlayerElement, existingPlayerElement = playerElementById[targetPlayerID], playerElementById[newPlayerID]
        local targetPlayerAccountName, existingPlayerAccountName = accountNameById[targetPlayerID], accountNameById[newPlayerID]

        if not targetPlayerAccountName then
            return outputChatBox('ID do jogador alvo não encontrado!', player, 255, 0, 0)
        end
        
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

        triggerClientEvent('IDSystem.Change', resourceRoot, targetPlayerID, newPlayerID)

        outputChatBox('ID ' .. targetPlayerID .. ' trocado para ' .. newPlayerID .. ' com sucesso!', player, 0, 255, 0)
        
        if config.logsDiscord then
            local template = 'Administrador: **%s**\nJogador alvo: **%s**\nNovo ID: **%s**\nData: <t:%s>'
            sendDiscordMessage(config.logs.title, string.format(template, playerIdByElement[player], targetPlayerID, newPlayerID, os.time()))
        end
    end
end)

addEvent('IDSystem.InitializeMapping', true)
addEventHandler('IDSystem.InitializeMapping', resourceRoot, function(client)
    triggerClientEvent(client, 'IDSystem.Mapping', resourceRoot, playerIdByElement, accountNameById)
end)

function hasPermission(player)
    local account = getPlayerAccount(player)
    if isGuestAccount(account) then
        return false
    end

    local accountName = getAccountName(account)
    local aclGroup = aclGetGroup(config.allowedACL)

    return aclGroup and isObjectInACLGroup('user.' .. accountName, aclGroup) or false
end

function sendDiscordMessage(title, message)
    if not title or not message then
        return
    end

    local data = toJSON ({
        tts = false;
        embeds = {
            {
                type = 'rich',
                title = title,
                description = message,
                color = config.logs.color
            };
        };
    });

    fetchRemote (config.logs.url, { method = 'POST', headers = { ['Content-Type'] = 'application/json' }, postData = data:sub (3, (#data - 2)) }, function() end)
end

addEventHandler('onResourceStart', resourceRoot, function(resource)
    local resourceName = getResourceName(resource)
    
    if config.logsDiscord and not isObjectInACLGroup('resource.' .. resourceName, aclGetGroup('Admin')) then
        outputDebugString('Adicione o resource '..resourceName..' na ACL Admin para permitir o envio de logs ao Discord!', 2)
        cancelEvent()
    end
end)

addEventHandler('onPlayerLogin', root, function(_, account)
    local playerId = exports['IDSystem']:getPlayerIdByElement(localPlayer)
    local accountName = exports['IDSystem']:getAccountNameById(playerId)

    if playerId and accountName then
        outputChatBox('seu ID é: ' .. playerId .. ' e sua conta é: ' .. accountName, 0, 255, 0)
    else
        outputChatBox('Não foi possível obter as informações do jogador.', 255, 0, 0)
    end
end)