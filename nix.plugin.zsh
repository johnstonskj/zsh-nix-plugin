# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name nix
# @brief Zsh plugin to initialize nix package manager
# @repository https://github.com/johnstonskj/zsh-nix-plugin
# @homepage **include if different from repository URL**
# @version 0.1.0
#
# @description
#
# Primarily manage the path to nix binaries.
#
# ### Public Variables
#
# * **NIX_PROFILE**: Name of the nix profile to use, if not set the value 'default' will be used.
#

############A#######################################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

@zplugins_declare_plugin_dependencies nix shlog

#
# @description
#
# Configure the environment variable `NIX_PROFILE` and set the path to include the nix `bin`
# directory.
#
# @noargs
#
nix_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Save current state of `NIX_PROFILE` and initialize if not set.
    @zplugin_save_global nix "${NIX_PROFILE:-default}"

    # Add nix `bin` directory to path.
    local nix_bin="/nix/var/nix/${NIX_PROFILE}/bin"
    if [[ -d "${nix_bin}" ]]; then
        log_error "zsh-nix: path to nix binaries doesn't exist; path: '${nix_bin}'."
    else
        @zplugin_add_to_path nix nix_bin
    fi
}

#
# @description
#
# Called when the plugin is unloaded to clean up after itself.
#
# @noargs
#
nix_plugin_unload() {
    builtin emulate -L zsh

    # Reset global environment variables.
    @zplugin_restore_global nix NIX_PROFILE

    unset PLUGIN
}
