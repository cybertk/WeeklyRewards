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
}

local function DefaultCharacterSorter(a, b)
	if type(a.lastUpdate) == "number" and type(b.lastUpdate) == "number" then
		return a.lastUpdate > b.lastUpdate
	end
	return strcmputf8i(a.name, b.name) < 0
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

function CharacterStore:ForEach(callback, filter, sorter)
	local characters = {}

	filter = filter or function(x)
		return x.enabled
	end
	sorter = sorter or DefaultCharacterSorter

	for _, character in pairs(self) do
		if filter(character) then
			table.insert(characters, 1, character)
		end
	end

	table.sort(characters, sorter)

	for _, character in ipairs(characters) do
		callback(character)
	end

	return characters
end
