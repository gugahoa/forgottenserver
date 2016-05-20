function onUse(cid, item, fromPosition, target, toPosition, isHotkey)
	local chest = Container(item.uid)
	local player = Player(cid)
	if not chest or not player then
		return true
	end

	local uniqueid = chest:getUniqueId()
	if player:getStorageValue(uniqueid) == -2 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "It is empty.")
		return true
	end

	local start = player:getStorageValue(uniqueid) == -1 and 0 or player:getStorageValue(uniqueid)
	for i = start, chest:getSize() do
		local reward = chest:getItem(i)
		if not reward then
			break
		end

		local rewardWeight = reward.getWeight and reward:getWeight() or ItemType(reward:getId()):getWeight(reward:getCount())
		if rewardWeight > player:getFreeCapacity() then
			player:sendTextMessage(MESSAGE_INFO_DESCR, 'You have found a ' .. reward:getName() .. ' weighing ' .. rewardWeight/100 .. ' oz it\'s too heavy.')
			player:setStorageValue(uniqueid, i)
			break
		else
			reward = reward:clone()
			if player:addItemEx(reward) ~= RETURNVALUE_NOERROR then
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'You have found a ' .. reward:getName() .. ' weighing ' .. rewardWeight/100 .. ' oz it\'s too heavy.')
				break
			end

			local reward_msg = reward:getArticle() .. ' ' .. reward:getName()
			if reward:getCount() > 1 then
				reward_msg = reward:getCount() .. ' ' .. reward:getPluralName()
			end

			player:sendTextMessage(MESSAGE_INFO_DESCR, 'You have found ' .. reward_msg .. '.')

			player:setStorageValue(uniqueid, -2)
		end
	end

	return true
end
