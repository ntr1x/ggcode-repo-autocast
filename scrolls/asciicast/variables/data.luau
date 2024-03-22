local ac = require("asciicast")
local object = require('core/util/object')

local session = ac.session()

local prompt = function(path)
  return session.directory(path) and object.spread({
    user = "dev@pc",
    path = path,
    prompt = "$"
  })
end

local res = {
  prompt "/tmp" {
    path = '~',
    sequence = {
      session.eval "echo Hello",
      session.eval "mkdir ./my-application",
      session.eval_with_overrides "cd ./my-application" { input = "cd ./my", complete = "-application" },
    },
  },
  prompt "/tmp/my-application" {
    path = '~/my-application',
    sequence = {
      session.eval "ggcode --help",
      session.eval "ggcode init --help",
      session.eval "ggcode init --name Demo --repository core:git@github.com:ntr1x/ggcode-repo-core.git --target @:.",
      session.eval "ggcode install",
      session.eval_with_overrides "ls -la --color=always" { input = "ls -la" }
    }
  }
}

return res