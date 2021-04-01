if Config.enableESX then
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  print('ESX ON')
end

local pickups = {}
for k,v in pairs(Config.coords) do
  pickups[k] = {GetHashKey(Config.models[k]), v, Config.coords[k]}
end

local stats_data = LoadResourceFile(GetCurrentResourceName(), 'stats.json')
local stats = {}
if stats_data then
  stats = json.decode(stats_data)
end

if Config.advanceCount then
  for k,v in pairs(stats) do
    local count = 0
    for i,d in pairs(v.pickups) do
      count = count + 1
    end

    v.count = count
  end
end

local function GetPlayerLicense(ids)
  for _,v in pairs(ids) do
    if string.find(v, 'license') then
      return v
    end
  end

  return false
end

RegisterNetEvent('paques:takePuckup')
AddEventHandler('paques:takePuckup', function(pickupId)
  local ids = GetPlayerIdentifiers(source)
  local license = GetPlayerLicense(ids)
  local xPlayer = ESX.GetPlayerFromId(source)
  local data = stats[license]

  if not data then
    stats[license] = {
      count = 0,
      pickups = {}
    }
  end

  stats[license].pickups[pickupId] = true

  if Config.advanceCount then
    local count = 0
    for i,d in pairs(stats[license].pickups) do
      count = count + 1
    end

    stats[license].count = count
  else
    stats[license].count = stats[license].count + 1
  end
  if not Config.enableitemsESX then
    if stats[license].count == #Config.coords then
      if Config.enable_rewardmoney then
        TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected_all)
        xPlayer.addMoney(Config.amount_rewardmoney)
        xPlayer.showNotification(Config.texts[Config.locale].reward)
      else
        TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected_all)
      end
    else
      TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected..' ('..stats[license].count..'/~b~'..#Config.coords..'~s~)')
    end
  else
    if stats[license].count == #Config.coords then
      if Config.enable_rewardmoney then
        TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected_all)
      else
        TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected_all)
        xPlayer.addMoney(Config.amount_rewardmoney)
        xPlayer.showNotification(Config.texts[Config.locale].reward)
      end
    else
      TriggerClientEvent('paques:notify', source, Config.texts[Config.locale].collected..' ('..stats[license].count..'/~b~'..#Config.coords..'~s~)')
      xPlayer.addInventoryItem('oeuf_paques', stats[license].count)
    end
  end
  SaveResourceFile(GetCurrentResourceName(), 'stats.json', json.encode(stats), -1)
end)

RegisterNetEvent('paques:requestData')
AddEventHandler('paques:requestData', function()
  local ids = GetPlayerIdentifiers(source)
  local license = GetPlayerLicense(ids)
  if license then
    local data = stats[license] or {
      count = 0,
      pickups = {}
    }
    TriggerClientEvent('paques:receiveData', source, data, pickups)
  else
    print('PAS DE LISCENCE POUR? : '..source)
  end
end)