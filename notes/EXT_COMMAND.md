# PearlB2's extension command (2026-10-26)

Black 2's field scripts can't call new code: the command table (decomp `src/ov012/scrcmd_vm.c`, `EVCMD_TABLE`) has a
fixed size. So one entry of it, command **0x15F** (`s015F_Nop`, which no Black 2 script uses: no `Cmd_015F` in the
decomp's res/), points at PearlB2's dispatcher, and every new script command PearlB2 needs is a sub-command of it
(lead's decision, 2026-10-26).

## In a script
```
    FieldCommand 351        // 0x15F
    .byte <sub-command>
    <the sub-command's own arguments>
```
`src/include/pearl_story.inc` has `pl_ext sub` for the first two lines; each module's macros add their arguments.
Arguments are read byte by byte (Black 2's VM_Read16), so any byte alignment works. A value-or-var argument is
`ScriptReadAny` (a number, or the value of the var it names, ids from 0x4000), a var argument is `ScriptReadVar`.

## The code
- Decomp `src/pearlb2/ext_cmd_itcm.c` (ITCM, always loaded): `PearlB2_ScrCmd_Ext` reads the sub-command byte; its top
  three bits pick the module's row, the module gets the low five bits. An empty row, or a sub-command its module
  doesn't know, stops the script (`VM_Halt`): its arguments' length is unknown.
- `include/pearlb2/ext_cmd.h`: the ranges and the handler type `BOOL handler(VM *vm, FieldScriptEnv *env, u32 sub)`.
  A handler returns what a script command returns: FALSE goes on with the next command, TRUE makes the script wait a
  frame, or until the native callback it set with `VM_SetNativeCallback` returns TRUE.
- `src/ov012/scrcmd_vm.c`: entry 0x15F of `EVCMD_TABLE` = `PearlB2_ScrCmd_Ext` (`#if PEARLB2`, `s015F_Nop` under
  `#else`; a pointer for a pointer, nothing moves).

## Ranges
| Sub-commands | Module | Handler |
|---|---|---|
| 0x00-0x1F | the Pokétch | `PearlB2_Ext_Poketch` (src/pearlb2/poketch_itcm.c) |
| 0x20-0x3F | the Underground | its agent adds its row |
| 0x40-0x5F | Pal Park | its agent adds its row |
| 0x60-0xFF | free | ask the lead |

## The Pokétch's sub-commands (notes/POKETCH.md)
| Sub | Macro (Platinum's names, as the other pl_ macros) | Arguments | Pearl's command (pokediamond's name) |
|---|---|---|---|
| 0x00 | `pl_EnablePoketch` | - | 0x131 GivePoketch: the Pokétch given; the bottom screen fades to it (the script waits) |
| 0x01 | `pl_CheckPoketchEnabled var` | var | 0x132 CheckPoketch: var = 1 if given |
| 0x02 | `pl_RegisterPoketchApp app` | value or var | 0x133 UnlockPoketchApp (the Pedometer also starts counting) |
| 0x03 | `pl_CheckPoketchAppRegistered app, var` | value or var, var | 0x134 CheckPoketchApp: var = 1 if registered |
| 0x04 | `pl_HidePoketch` | - | 0x265: Pearl's flag 0x97C set (no Pokétch from the next bottom-screen start) |
| 0x05 | `pl_ShowPoketch` | - | 0x266: flag 0x97C cleared |
