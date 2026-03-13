# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: nix
# @brief: Initialize THE Nix package manager
# @repository: https://github.com/johnstonskj/zsh-nix-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#
# @description
#
# Primarily manage the path to nix binaries.
#
# ### Public Variables
#
# * **NIX_PROFILE**: Name of the nix profile to use, if not set the value 'default' will be used.
#

NIX_ROOT="/nix"

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

    if [[ -d "${NIX_ROOT}" ]]; then
        # Save current state of `NIX_PROFILE` and initialize if not set.
        @zplugins_envvar_save nix NIX_PROFILE
        typeset -g NIX_PROFILE="${NIX_PROFILE:-default}"

        # Add nix `bin` directory to path.
        local nix_bin="${NIX_ROOT}/var/nix/profiles/${NIX_PROFILE}/bin"
        if [[ -d "${nix_bin}" ]]; then
            log_error "zsh-nix: path to nix binaries doesn't exist; path: '${nix_bin}'."
        else
            echo "adding nix @ ${nix_bin}"
            @zplugins_add_to_path nix "${nix_bin}"
        fi
        return 0
    else
        log_error "zsh-nix: there's no '${NIX_ROOT}' directory, is nix installed?"
        return 1
    fi
}

#
# @description
#
# Called when the plugin is unloaded to clean up after itself.
#
# @noargs
#
nix_plugins_unload() {
    builtin emulate -L zsh

    # Reset global environment variables.
    @zplugin_envvar_restore nix NIX_PROFILE
    return 0
}
