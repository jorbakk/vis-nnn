--- Copyright (C) 2023  Jörg Bakker
---
--- FIXME vis doesn't restore the terminal properly after exiting when 'nnn' has been called
--- solutions:
--- 1. 'e' alias for vis always appends a call to the clear(1) command
--- 2. introduce save_screen_state() and restore_screen_state() functions in vis
---    for test code, see: /home/jorg/cc/testlab/curses/leave_curses.c
---    there already are functions ui_curses_save() and ui_curses_restore()
---    which are used in vis_pipe()
---    these new functions could be added to vis.h (also in lua vis module then ...?)
--- FIXME also need to hide the cursor when leaving 'nnn' with curs_set(0)
module = {}

vis:command_register("nnn", function(argv, force, win, selection, range)
	--- TODO need to call curses functions: def_prog_mode(); endwin();
	--- TODO need to hide the curses cursor after exiting nnn
    local pickfile_name = os.tmpname()
    os.execute(string.format("nnn -RuA -p %s", pickfile_name))
    pickfile = io.open(pickfile_name)
    local output = {}
    for line in pickfile:lines() do
        table.insert(output, line)
    end
    local success, msg, status = pickfile:close()
    os.remove(pickfile_name)
    if success and output[1] ~= nil then
        vis:feedkeys(string.format(":e '%s'<Enter>", output[1]))
    end
    --- TODO need to call curses function: reset_prog_mode()
    vis:redraw()
    return true;
end, "Select file to open with nnn")

return module
