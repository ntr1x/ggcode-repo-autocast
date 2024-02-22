local function spread(template)
  return function(table)
    local result = {}
    for key, value in pairs(template) do
        result[key] = value
    end
    for key, value in pairs(table) do
        result[key] = value
    end
    return result
  end
end

local function eval(command)
  return {
    input = command,
    output = shell:exec(command)
  }
end

local function eval_with_overrides(command)
  return function(overrides)
    return {
      input = overrides.input,
      complete = overrides.complete,
      output = shell:exec(command)
    }
  end
end

local prompt = spread({
  user = "dev@pc",
  path = "~",
  prompt = "$"
})

return {
  prompt {
    path = "~",
    sequence = {
      eval "echo Hello",
      eval "mkdir ./my-application",
      eval_with_overrides "cd ./my-application" { input = "cd ./my", complete = "-application" }
    },
  },
  prompt {
    path = "~/my-application",
    sequence = {
      eval "ggcode --help",
      eval "ggcode init --help",
      eval_with_overrides "cd ./my-application && ggcode init" { input = "ggcode init" },
      eval_with_overrides "cd ./my-application && ggcode install" { input = "ggcode install" },
      eval_with_overrides "cd ./my-application && ls -la --color=always" { input = "ls -la" }
    }
  }
}
