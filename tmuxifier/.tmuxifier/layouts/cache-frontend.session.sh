# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/code/projects/cache/react-app"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "cache-frontend"; then
  new_window "editor"
  new_window "server"
  new_window "lazygit"

  select_window 0
  run_cmd "nvim -c 'vsplit .'"

  select_window 1
  run_cmd "npm start"

  select_window 2
  run_cmd "lazygit"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
