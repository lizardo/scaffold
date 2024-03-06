#!/bin/bash
set -eu

run_steps() {
	nsteps=0
	for step in steps/[0-9][0-9]-*.sh; do
		if [[ ! -x "${step}" ]]; then
			echo "Skipping ${step}..." >&2
			continue
		fi
		echo "Processing ${step}..." >&2
		commands="$(sed -n '4,$p' "${step}")"
		commit_title="$(sed -n '3s/^# *//p' "${step}")"
		cat <<-__EOF
			### File: ${step}

			${commands}

			git add .
			git commit -m '${commit_title}'

		__EOF
		nsteps=$((nsteps + 1))
	done
	echo "Processed ${nsteps} steps" >&2
}

output="$(
	set -e
	run_steps
)"

if [[ -n "${output}" ]]; then
	cat <<-__EOF | shfmt
		#!/bin/bash
		set -eu
		### Common initialization

		function jq_inplace() {
			filter="\$1"
			file="\$2"
			jq "\${filter}" "\${file}" > "\${file}.tmp"
			mv "\${file}.tmp" "\${file}"
		}

		git init output.git
		cd output.git

		${output}
	__EOF
fi
