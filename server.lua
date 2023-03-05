local QBCore = exports['qb-core']:GetCoreObject()
local joinTime = 0

-- IsPlayerLoaded
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    joinTime = os.time()
end)

-- PlayerData Callback
QBCore.Functions.CreateCallback('getPlayerData', function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)

	if not xPlayer then
		return
	end
    Datas = {
        name = xPlayer.PlayerData.charinfo.firstname .." ".. xPlayer.PlayerData.charinfo.lastname,
        job = xPlayer.PlayerData.job.name,
        cash = xPlayer.PlayerData.money.cash,
        id = source,
    }

    cb(Datas)
end)


-- Disconnect Callback
QBCore.Functions.CreateCallback('disconnectPlayer', function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.Kick('Goodbye!') -- Disconnect the player
    timeNow = 0 -- Set back to zero
end)

-- GetPlayTime Callback
QBCore.Functions.CreateCallback('getPlayTime', function(source, cb)
    local playerTime = QBCore.Functions.ConvertToMinutes(os.time() - joinTime)
    cb(playerTime)
end)

-- Send Report To Discord
QBCore.Functions.CreateCallback('sendReportToDiscord', function(source, cb, message)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if #message[1] == 0 or #message[2] == 0 then
        TriggerClientEvent('esx:showNotification', source, config.discord_error_message, "error")
    else 
        sendToDiscord(config.discord_WebhookColor, message[2], message[1], config.discord_footer_message .. xPlayer.getName(), config.discord_Webhook, config.discord_WebhookName)
    end 
end)


function QBCore.Functions.ConvertToMinutes(sec)
    return math.floor((sec % 3600) / 60)
end

function sendToDiscord(color, name, message, footer, url, webHookName)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = footer,
              },
          }
      }
  
    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = webHookName, embeds = embed}), { ['Content-Type'] = 'application/json' })
  end

