# Source this before working:  source env.sh
# Puts the project's tools on PATH (nothing is installed system-wide).
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/llvm/bin:$PATH"
export PEARL="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
alias melonds='open -a "$HOME/Applications/melonDS.app"'
export SDL_AUDIODRIVER=dummy   # emulator tests are silent
