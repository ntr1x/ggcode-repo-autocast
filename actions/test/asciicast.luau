local ggcode = require("core/ggcode")
local asciicast = require("asciicast")

local session = asciicast.session()

ggcode.generate "@/asciicast" {
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
