local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('SmallTattoos:GetPlayerTattoos', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player then
		exports.oxmysql:execute('SELECT tattoos FROM players WHERE citizenid = ?', { Player.PlayerData.citizenid }, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

QBCore.Functions.CreateCallback('SmallTattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player.PlayerData.money.cash >= price then
		Player.Functions.RemoveMoney('cash', price)
		table.insert(tattooList, tattoo)

		exports.oxmysql:update('UPDATE players SET tattoos = ? WHERE citizenid = ?', { json.encode(tattooList), Player.PlayerData.citizenid })

		TriggerClientEvent('QBCore:Notify', src, "You have bought the ~y~" .. tattooName .. "~s~ tattoo for ~g~$" .. price, "success", 4000)
		cb(true)
	else
		TriggerClientEvent('QBCore:Notify', src, "You do not have enough money for this tattoo", "success", 4000)
		cb(false)
	end
end)

RegisterServerEvent('SmallTattoos:RemoveTattoo')
AddEventHandler('SmallTattoos:RemoveTattoo', function (tattooList)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	exports.oxmysql:update('UPDATE players SET tattoos = ? WHERE citizenid = ?', { json.encode(tattooList), Player.PlayerData.citizenid })
end)