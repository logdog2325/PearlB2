#!/bin/zsh
# usage: title_tune.sh "x y z" "tx ty tz" tag   (camera position / target in model units) -> work/title_test/tune_<tag>.png
set -e
P=$HOME/Documents/GitHub/PearlB2
cd $P/b2tools
PEARL_TITLE_CAM="$1" PEARL_TITLE_LOOK="$2" PEARL_BUILD_DIR=$P/work/rom_title python3 build_rom.py --clean antipiracy pearl_title 2>&1 | grep -E 'pearl_title|Error|error' | tail -2
SDL_AUDIODRIVER=dummy ~/Documents/GitHub/HoennB2/.venv/bin/python - "$3" 2>&1 <<'PY' | grep -E 'shot|Error'
import sys, os; sys.path.insert(0, '.')
from emu import Emu, fresh_battery
rom = os.path.expanduser('~/Documents/GitHub/PearlB2/work/rom_title/pearl.nds')
fresh_battery(rom); e = Emu(rom); e.run(1500)
out = os.path.expanduser(f'~/Documents/GitHub/PearlB2/work/title_test/tune_{sys.argv[1]}.png')
e.shot(out, 'bottom'); print('shot', out)
PY
