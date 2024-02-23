local function session()
  local _directory = '.'

  local function eval(command)
    return {
      input = command,
      output = shell:exec(_directory, command)
    }
  end

  local function directory(path)
    _directory = path
    return true
  end

  local function eval_with_overrides(command)
    return function(overrides)
      return {
        input = overrides.input,
        complete = overrides.complete,
        output = shell:exec(_directory, command)
      }
    end
  end

  return {
    directory = directory,
    eval = eval,
    eval_with_overrides = eval_with_overrides,
  }
end

return {
  session = session
}
