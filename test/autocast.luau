local ggcode = require("ggcode")
local autocast = require("autocast")

local session = autocast.session()

ggcode.generate "@/autocast" {
    target = '@examples',
    variables = {
        bundle = { name = 'basic' },
        data = {
            session.prompt "/tmp" {
                path = '~',
                sequence = {
                    session.eval "pwd",
                    session.eval "id",
                    session.eval "ls -la --color=always /",
                }
            }
        }
    }
}
