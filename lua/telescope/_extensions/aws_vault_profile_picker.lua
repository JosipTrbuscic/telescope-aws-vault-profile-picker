return require("telescope").register_extension {
  setup = function(ext_config, config)
  end,
  exports = {
    stuff = require("aws_vault_profile_picker").stuff
  },
}
