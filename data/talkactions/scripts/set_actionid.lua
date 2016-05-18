function onSay(cid, words, param)
	local player = Player(cid)

	if not player then
		return false
	end

	if not player:getGroup():getAccess() then
		return true
	end

	if not tonumber(param) then
		player:sendCancelMessage("Need a number param.")
		return false
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	if not tile then
		player:sendCancelMessage("Object not found.")
		return false
	end

	local thing = tile:getTopVisibleThing(player)
	if not thing then
		player:sendCancelMessage("Thing not found.")
		return false
	end

	if thing:isCreature() then
		player:sendCancelMessage("You can't give an action id to a creature.")
	elseif thing:isItem() then
		local actionid = tonumber(param)
		if actionid <= 0 then
			thing:removeAttribute(ITEM_ATTRIBUTE_ACTIONID)
		else
			thing:setActionId(actionid)
		end
	end

	position:sendMagicEffect(CONST_ME_MAGIC_RED)
	return false
end
