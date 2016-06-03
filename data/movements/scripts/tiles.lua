local increasing = {[416] = 417, [426] = 425, [446] = 447, [3216] = 3217, [3202] = 3215, [11062] = 11063}
local decreasing = {[417] = 416, [425] = 426, [447] = 446, [3217] = 3216, [3215] = 3202, [11063] = 11062}

local function switchDecayState(depot, get, set)
	for i = 0, depot:getSize() - 1 do
		local item = depot:getItem(i)
		if get(item, ITEM_ATTRIBUTE_DECAYSTATE) then
			set(item, ITEM_ATTRIBUTE_DECAYSTATE, 0)
		end

		if item:isContainer() then
			switchDecayState(item, get, set)
		end
	end
end

function onStepIn(creature, item, position, fromPosition)
	if not increasing[item.itemid] then
		return true
	end

	local player = creature:getPlayer()
	if player == nil or player:isInGhostMode() then
		return true
	end

	item:transform(increasing[item.itemid])

	if item.actionid >= 1000 then
		if player:getLevel() < item.actionid - 1000 then
			player:teleportTo(fromPosition, false)
			position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:sendTextMessage(MESSAGE_INFO_DESCR, "The tile seems to be protected against unwanted intruders.")
		end
		return true
	end

	if Tile(position):hasFlag(TILESTATE_PROTECTIONZONE) then
		local lookPosition = player:getPosition()
		lookPosition:getNextPosition(player:getDirection())
		local depotItem = Tile(lookPosition):getItemByType(ITEM_TYPE_DEPOT)
		if depotItem ~= nil then
			local depot = player:getDepotChest(getDepotId(depotItem:getUniqueId()), true)
			local depotItems = depot:getItemHoldingCount()
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Your depot contains " .. depotItems .. " item" .. (depotItems > 1 and "s." or "."))

			switchDecayState(depot, Item.canDecay, Item.decay)
			switchDecayState(player:getInbox(), Item.canDecay, Item.decay)
			return true
		end
	end

	if item.actionid ~= 0 and player:getStorageValue(item.actionid) <= 0 then
		player:teleportTo(fromPosition, false)
		position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "The tile seems to be protected against unwanted intruders.")
		return true
	end
	return true
end

function onStepOut(creature, item, position, fromPosition)
	if not decreasing[item.itemid] then
		return true
	end

	local player = creature:getPlayer()
	if creature:isPlayer() and creature:isInGhostMode() then
		return true
	end

	item:transform(decreasing[item.itemid])
	if Tile(position):hasFlag(TILESTATE_PROTECTIONZONE) then
		local lookPosition = fromPosition
		lookPosition:getNextPosition(Game.getReverseDirection(player:getDirection()))
		local depotItem = Tile(lookPosition):getItemByType(ITEM_TYPE_DEPOT)
		if depotItem ~= nil then
			local depot = player:getDepotChest(getDepotId(depotItem:getUniqueId()), true)
			switchDecayState(depot, Item.hasAttribute, Item.setAttribute)
			switchDecayState(player:getInbox(), Item.canDecay, Item.decay)
			return true
		end
	end
	return true
end
