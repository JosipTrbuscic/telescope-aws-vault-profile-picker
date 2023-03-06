local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error "This extension requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)"
end

return require("telescope").register_extension {
  setup = function(ext_config, config)
  end,
  exports = {
    profile_picker = require("aws_vault_profile_picker").profiles
  },
}
