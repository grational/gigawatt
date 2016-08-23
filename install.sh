#!/usr/bin/env bash
# install gigawatt remotely
# @version: 0.1b
# @author:  Giuseppe Ricupero
# @e-mail:  giuseppe.ricupero@gmail.com
# @update:  18-08-2016 16.38

install() {
	# bash unoffial strict mode
	set -euo pipefail
	# remove space as separator
	local IFS=$'\n\t'

	# local function
	exitmsg() { printf "$*\n" >&2; exit 1; }

	local -a deps=(git)
	local user_bin=~/bin
	local ghub_dir=~/bin/github
	local inst_dir=~/bin/github/gigawatt
	local shell_cfg=~/.profile

	# check deps
	for com in "${deps[@]}"; do
		if ! command -v "$com" >/dev/null 2>&1; then
			exitmsg "'${com}' executable is required to run ${name}. Aborting."
		fi
	done

	# check for an already present gigawatt executable
	local gw_check="$(command -v gigawatt || echo none)"
	if [[ $gw_check != none ]]; then
		exitmsg "It seems that you already have a gigawatt executable: '${gw_check}'.\nAborting installation."
	fi

	# abort installation for existing default dir
	[[ -d $inst_dir ]] && \
		exitmsg 'Seems that you have already installed gigawatt. Update using:\n  cd ~/bin/github/gigawatt && git pull'

	# create local path
	[[ ! -d $user_bin ]] && mkdir "${user_bin}"
	# add local ~/bin to PATH if needed
	[[ ! ${PATH} =~ $user_bin ]] && \
		printf '# gigawatt install script\nexport PATH="${HOME}/bin:${PATH}"' >> "${shell_cfg}"
	# create ~/bin/github dir if needed
	[[ ! -d ${ghub_dir} ]] && mkdir "${ghub_dir}"
	# clone gigawatt repo
	git clone 'https://github.com/grecovery/gigawatt' "$inst_dir"
	# add a softlink to execute gigawatt
	ln -s "$inst_dir/gigawatt" "$user_bin"
}

install

# vim: ft=zsh:fdm=marker
