function Item.getType(self)
	return ItemType(self:getId())
end

function Item.canDecay(self)
	return self:getType():getDecayId() and self:hasAttribute(ITEM_ATTRIBUTE_DURATION) and not self:hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)
end

function Item.isContainer(self)
	return false
end

function Item.isCreature(self)
	return false
end

function Item.isPlayer(self)
	return false
end

function Item.isTeleport(self)
	return false
end

function Item.isTile(self)
	return false
end
