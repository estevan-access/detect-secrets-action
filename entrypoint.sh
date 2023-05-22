#!/bin/bash

set -o pipefail
set -exu

if [ $GITHUB_ACTIONS ]
then
	git config --global --add safe.directory $GITHUB_WORKSPACE
fi

if [ ! -r "$DS_BASELINE_FILE" ]
then
	if [ $DS_REQUIRE_BASELINE -eq 0 ]
	then
		detect-secrets scan --all-files > "$DS_BASELINE_FILE"
		exit 0
	else
		echo "No readable detect-secrets baseline file found at '$DS_BASELINE_FILE', and it was set to required by \$DS_REQUIRE_BASELINE ($DS_REQUIRE_BASELINE)"
		exit -1
	fi
fi

if [ $DS_AUDIT_BASELINE -eq 1 ]
then
	detect-secrets audit $DS_ADDL_ARGS "$DS_BASELINE_FILE"
	exit 0
fi

git ls-files -z | xargs -0 detect-secrets-hook --baseline "$DS_BASELINE_FILE" $DS_ADDL_ARGS
