local function ansi_green(st)
	return `\\u001b[32m{st}\\u001b[00m`
end

local function ansi_blue(st)
	return `\\u001b[34m{st}\\u001b[00m`
end

template:println(`\{"version": {config.meta.version}, "width": {config.meta.width}, "height": {config.meta.height}, "timestamp": {config.meta.timestamp}, "env": \{"SHELL": "{config.meta.env.SHELL}", "TERM": "{config.meta.env.TERM}"}}`)
local time = 0
for group_index, group in data do
  time += (group.wait and group.wait.before) or (config.group and config.group.wait and config.group.wait.before) or 0
  if group.sequence then
    for item_index, item in group.sequence do
      if item.input then
        time += (config.prompt and config.prompt.wait and config.prompt.wait.before) or 0
        template:println(`[{string.format('%.02f', time)}, "o", "{ansi_green(group.user)}:{ansi_blue(group.path)}$ "]`)
        time += (config.prompt and config.prompt.wait and config.prompt.wait.after) or 0
      end
      time += (item.wait and item.wait.before) or (config.item and config.item.wait and config.item.wait.before) or 0
      if item.input then
        for ch in item.input:gmatch(".") do
          time += (config.char and config.char.wait and config.char.wait.before) or 0
          template:println(`[{string.format('%.02f', time)}, "o", "{ch}"]`)
          time += (config.char and config.char.wait and config.char.wait.after) or 0
        end
        if item.complete then
          template:println(`[{string.format('%.02f', time)}, "o", "{item.complete}"]`)
        end
      end
      time += (item.wait and item.wait.after) or (config.item and config.item.wait and config.item.wait.after) or 0
      template:println(`[{string.format('%.02f', time)}, "o", "\\r\\n"]`)
      if item.output then
        local lines = {}
        for line in item.output:gmatch("([^\n]*)\n?") do
          lines[#lines + 1] = line
        end
        for i, line in lines do
          if i == #lines then
            template:println(`[{string.format('%.02f', time)}, "o", "\\r{line}"]`)
          else
            template:println(`[{string.format('%.02f', time)}, "o", "\\r{line}\\r\\n"]`)
          end
        end
        time += (item.wait and item.wait.after) or (config.item and config.item.wait and config.item.wait.after) or 0
        -- template:println(`[{string.format('%.02f', time)}, "o", "\\r\\n"]`)
      end
    end
  end
  time += (group.wait and group.wait.after) or (config.group and config.group.wait and config.group.wait.after) or 0
  if group_index == #data then
    time += (config.prompt and config.prompt.wait and config.prompt.wait.before) or 0
    template:println(`[{string.format('%.02f', time)}, "o", "{ansi_green(group.user)}:{ansi_blue(group.path)}$ "]`)
    time += (config.prompt and config.prompt.wait and config.prompt.wait.after) or 0
  end
end
