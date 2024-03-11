config = {
    -- Comando para trocar ID do jogador (exemplo: /changeid idAlvo novoID)
    changeIDCommand = 'changeid';

    -- ACL permitida para trocar ID do jogador
    allowedACL = 'Admin';

    -- Indica se deve enviar logs para o Discord quando algum admin trocar o ID de um jogador
    logsDiscord = true;

    -- Configurações de log
    logs = {
        title = 'Troca de ID',
        url = 'Url do WebHook',
        color = '3447003', -- Cor do Embed (https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812?permalink_comment_id=4037826)
    }
}