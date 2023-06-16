--- Copyright (C) 2023  Jörg Bakker
---

local module = {}
module.nnn_args = ""

vis:command_register("nnn", function(argv, force, win, selection, range)
    local pickfile_name = os.tmpname()
    local status = vis:pipe(nil, nil, string.format("nnn " .. module.nnn_args .. " -p %s", pickfile_name), true)
    local pickfile = io.open(pickfile_name)
    if not pickfile then
	    vis:redraw()
		return false
    end
    local output = {}
    for line in pickfile:lines() do
        table.insert(output, line)
    end
    local success, msg, status = pickfile:close()
    os.remove(pickfile_name)
    if success and output[1] ~= nil then
        vis:feedkeys(string.format(":e '%s'<Enter>", output[1]))
    end
    return true;
end, "Select file to open with nnn")

return module
