function Dump(obj)
    local str = LuaToJSON(obj)
	ModLog("Dumping object: " .. str)
end
