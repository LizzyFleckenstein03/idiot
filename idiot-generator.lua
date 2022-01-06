#! /usr/bin/env lua

local commands = {}
local pf = io.popen("git help -a")

for line in pf:lines() do
	if line:sub(1, 3) == "   " then
		for i = 4, line:len() do
			if line:sub(i, i) == " " then
				table.insert(commands, line:sub(4, i - 1))
				break
			end
		end
	end
end

pf:close()

local f = io.open("idiot", "w")
f:write("#! /bin/bash\n")
f:write("args=\"${@:2:$#}\"\n")

f:write("case $1 in\n")

for _, cmd in ipairs(commands) do
	io.stdout:write(cmd .. ": ")
	f:write("\"" .. io.stdin:read("*l") .. "\")\n")
	f:write("git " .. cmd .. " $args\n")
	f:write(";;\n")
end

f:write("esac\n")
