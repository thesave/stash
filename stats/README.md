Stats is a bash function that reports statistics on the system.

Stats include a back-off timeout for source inclusion into `.bashrc`-like files (e.g., also `.bash_profile`, `.bash_prompt`).
The back-off timeout limits the printing of stats within a 10 minute time-frame (this works for `source .stats` commands, but calling `stats` from the terminal is unlimited).

Files:

- `.stats_linux` | for linux systems (tested on Ubuntu/Debian)
- `.stats_osx` | for osx/macOS systems (tested on 10.11)
