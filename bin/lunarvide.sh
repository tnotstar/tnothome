#!/bin/sh
# Copyright (c) 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>
# Stolen from: https://github.com/LunarVim/LunarVim/issues/1553#issuecomment-920247252

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-$CONFIG_HOME/lvim}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-$CACHE_HOME/lvim}"
export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-$DATA_HOME/lunarvim}"

exec neovide -- -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" "$@"
