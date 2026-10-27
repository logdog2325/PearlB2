"""The game version of a build: Pearl (default) or, later, Diamond (the HoennB2 HOENN_VERSION pattern;
HoennB2's full module is kept in reference/hoenn_version.py).

    PEARL_VERSION=pearl|diamond       (unset or empty = pearl; anything else stops the build)

Every tool that differs per version asks this module; nothing else reads PEARL_VERSION. A Pearl build must stay
byte-identical whether or not Diamond support exists (prove it with SHA-1s, as HoennB2 did for Ruby and Emerald).
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))

VERSIONS = ('pearl', 'diamond')
VERSION = (os.environ.get('PEARL_VERSION') or 'pearl').strip().lower()
if VERSION not in VERSIONS:
    raise SystemExit(f'PEARL_VERSION={VERSION!r}: expected one of {", ".join(VERSIONS)}')
DIAMOND = VERSION == 'diamond'

NAME = {'pearl': 'Pearl', 'diamond': 'Diamond'}[VERSION]
PUBLIC_NAME = f'Pokémon {NAME} NDS'
RELEASE_STEM = f'Pokemon_{NAME}_NDS'
SOURCE_GAME_CODE = {'pearl': 'APAE', 'diamond': 'ADAE'}[VERSION]   # the Gen 4 dump the content comes from
SOURCE_DUMP = os.path.join(ROOT, 'roms', f'{VERSION}.nds')
ENCOUNTER_NARC = {'pearl': 'fielddata/encountdata/p_enc_data.narc',
                  'diamond': 'fielddata/encountdata/d_enc_data.narc'}[VERSION]


def build_dir(default):
    """The ROM folder: PEARL_BUILD_DIR, else `default` (work/rom) for Pearl and default + '_diamond' for Diamond, so a
    Diamond build never writes the Pearl ROM."""
    d = os.environ.get('PEARL_BUILD_DIR')
    if d:
        return d
    return default + '_diamond' if DIAMOND else default
