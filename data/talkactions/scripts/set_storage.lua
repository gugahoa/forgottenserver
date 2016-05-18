-- Works for any TFS 1.X,
-- as long as versions after 1.2
-- maintain backward compatibility

function onSay(cid, words, param, type)
	local player = Player(cid)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GAMEMASTER then
		return false
	end

	-- Extract the specified parameters.
	local parameters = param:split(",")

	if parameters[3] == nil then
		player:sendCancelMessage("Insufficient parameters, usage: !setstorage playerName, key, value")
		return false
	end

	-- Remove trailing/leading white spaces from parameters.
	local playerName = (parameters[1] or ""):trim()
	local storageKey = tonumber(parameters[2]) or 0
	local storageValue = tonumber(parameters[3]) or 0

	-- Get meta player.
	local checkedPlayer = Player(playerName)

	if not checkedPlayer then
		player:sendCancelMessage(string.format("Could not find player '%s'.", playerName))

		player:getPosition():sendMagicEffect(CONST_ME_BUBBLES)

		return false
	end

	-- Set specified storage value on player.
	checkedPlayer:setStorageValue(storageKey, storageValue)

	-- Print the message in Local Chat in orange (only self can see).
	player:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format("Storage key '%s' was set to '%s' for player '%s'.", storageKey, storageValue, checkedPlayer:getName()))

	player:getPosition():sendMagicEffect(CONST_ME_BUBBLES)
end
