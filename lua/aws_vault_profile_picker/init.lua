local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local utils = require "telescope.utils"

local M = {}

local set_env_variable = function(key, value)
  local camel_key = "AWS_" .. string.upper(string.gsub(key, "(%l)([A-Z])", "%1_%2"))
  vim.env[camel_key] = value
end

M.profiles = function(opts)
  opts = opts or {}
  pickers.new(require("telescope.themes").get_dropdown(opts), {
    prompt_title = "AWS vault profiles",
    finder = finders.new_oneshot_job({"aws-vault", "list", "--profiles"}, opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function (prompt_bufnr, _)
      actions.select_default:replace(function ()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local json_output = utils.get_os_command_output({"aws-vault", "exec", "--json", "--no-session", selection[1]})
        local parsed_json = vim.json.decode(json_output[1])
        for key, value in pairs(parsed_json) do
          set_env_variable(key, value)
        end
        utils.notify("AWS profile set", {
          msg = "AWS profile " .. selection[1],
          level = "INFO",
        })
      end)
      return true
    end
  }):find()
end


return M
