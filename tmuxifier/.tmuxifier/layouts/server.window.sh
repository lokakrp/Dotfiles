# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
#window_root "~/Projects/server"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "server"

# Split window into panes.
split_h 50
split_v 50

select_pane 0
run_cmd "conda activate personal-finance-api"
run_cmd "cd api"
run_cmd "python main.py"
split_v 50

select_pane 1
run_cmd "cd react-app"
run_cmd "npm start"

select_pane 2
run_cmd 'mariadb -h 92.236.134.121 -u remote -D dbfinance -p'
