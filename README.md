# ID System
Este resource permite o gerenciamento eficiente de jogadores usando IDs correspondentes.

# Características
- Rápida busca de valores por meio de indexação direta;
- Troca permanente de IDs com log no Discord;

# Documentação
A documentação está disponível na página Wiki. [(clique aqui)](https://github.com/danilo-silvaa/mtasa-idsystem/wiki)

# Exemplo de Uso
- Este exemplo, no lado do cliente, informa ao jogador que executou o comando o seu ID correspondente.

```lua
addCommandHandler('myid', function()
    local playerId = exports['IDSystem']:getPlayerIdByElement(localPlayer)
    
    outputChatBox('Seu ID é: ' .. playerId, 0, 255, 0)
end)
```