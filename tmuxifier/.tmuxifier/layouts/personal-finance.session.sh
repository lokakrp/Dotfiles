# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/code/personal-finance"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "personal-finance"; then
  new_window "editor"
  run_cmd "conda activate personal-finance-api"
  run_cmd "nvim -c 'vsplit .'"
  
  load_window "server"

  new_window "worker"
  split_v 20
  select_pane 0
  run_cmd "conda activate personal-finance-worker"
  run_cmd "cd worker"
  run_cmd "nvim -c 'vsplit .'"
  select_pane 1
  run_cmd "cd worker"
  run_cmd "conda activate personal-finance-worker"

  new_window "git"
  run_cmd "lazygit"

  select_window 0
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
