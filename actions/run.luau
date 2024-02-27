local ggcode = require("ggcode")

ggcode.generate "@/autocast" {
    target = '@examples',
    variables = {
        bundle = { name = 'ggcode' }
    }
}
