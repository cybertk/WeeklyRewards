local _, namespace = ...

local CharacterStore = {}
namespace.CharacterStore = CharacterStore

local Util = namespace.Util
local Character = namespace.Character

local WAPI = {
	GetServerTime = GetServerTime,
}

local Cache = {
	instance = nil, -- Singleton
	sortOrder = "lastUpdate",
	secondarySortOrder = "name",
	ascending = true,
	secondaryAscending = true,
}

local function CharacterComparator(lhs, rhs, field)
	if lhs == rhs then
		return 0
	elseif lhs == nil then
		return -1
	elseif rhs == nil then
		return -1
	end

	if Cache.instance:CurrentPlayer()[field] then
		if lhs[field] == rhs[field] then
			return 0
		elseif lhs[field] == nil then
			return -1
		elseif rhs[field] == nil then
			return 1
		end

		return lhs[field] < rhs[field] and -1 or 1
	end

	if lhs.progress[field] == rhs.progress[field] then
		return 0
	elseif lhs.progress[field] == nil then
		return -1
	elseif rhs.progress[field] == nil then
		return 1
	end

	return lhs.progress[field] < rhs.progress[field] and -1 or 1
end

local function CreateCharacterSorter(primary, secondary, ascending, secondaryAscending)
	return function(a, b)
		local result = NegateIf(CharacterComparator(a, b, primary), ascending)
		if result == 0 then
			return NegateIf(CharacterComparator(a, b, secondary), secondaryAscending) < 0
		else
			return result < 0
		end
	end
end

function CharacterStore.Get()
	return Cache.instance
end

function CharacterStore.Load(characters)
	local store = CharacterStore.Get()

	if store == nil then
		return CharacterStore:New(characters)
	end

	for k, v in pairs(characters) do
		store[k] = Character:New(v)
	end
end

-- Load
function CharacterStore:New(o)
	if Cache.instance ~= nil then
		Util:Debug("CharacterStore RESET")
	end

	o = o or {}
	self.__index = self
	setmetatable(o, self)

	for k, v in pairs(o) do
		o[k] = Character:New(v)
	end

	Cache.instance = o
	return o
end

function CharacterStore:CurrentPlayer()
	local id = UnitGUID("player")
	if self[id] == nil then
		Util:Debug("Populating new player")
		self[id] = Character:New()
	end

	return self[id]
end

function CharacterStore:GetSortOrder()
	return Cache.sortOrder, Cache.ascending
end

function CharacterStore:SetSortOrder(field)
	if Cache.sortOrder == field then
		Cache.ascending = not Cache.ascending
	else
		Cache.secondarySortOrder = Cache.sortOrder
		Cache.secondaryAscending = Cache.ascending
	end

	Cache.sortOrder = field

	Util:Debug("Sorting:", Cache.sortOrder, Cache.secondarySortOrder, Cache.ascending, Cache.secondaryAscending)
end

function CharacterStore:ForEach(callback, filter)
	local characters = {}

	filter = filter or function(x)
		return x.enabled
	end
	for _, character in pairs(self) do
		if filter(character) then
			table.insert(characters, 1, character)
		end
	end

	table.sort(characters, CreateCharacterSorter(Cache.sortOrder, Cache.secondarySortOrder, Cache.ascending))

	for _, character in ipairs(characters) do
		callback(character)
	end

	return characters
end
