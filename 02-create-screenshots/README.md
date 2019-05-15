# Download videos

In runner directory, `mix run -e "Runner.download_vids()"`

# Create Screenshots From Videos

In runner directory, `mix run -e "Runner.make_screenshots()"`

# Data Cleanup - Merge Duplicate Games

`./step_3_cleanup_screenshots.exs`

# Data Cleanup - Delete black frames

`mix run -e "Runner.delete_black_frames()"`
