#!/bin/bash
# Copyright (C) 2016 Intel Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# This script is meant to be consumed by travis. It's very simple but running
# a loop in travis.yml isn't a great thing.
set -e

# Allow the user to specify another command to use for building such as podman.
if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

# Set docker tag as branch name
IFS='/'
read -ra REF <<< ${GITHUB_REF}
TAG="${REF[-1]}"

# Don't deploy on pull requests because it could just be junk code that won't
# get merged
if ([ "${GITHUB_EVENT_NAME}" = "push" ] || [ "${GITHUB_EVENT_NAME}" = "workflow_dispatch" ]); then
    echo $DOCKER_PASSWORD | ${ENGINE_CMD} login -u $DOCKER_USERNAME --password-stdin
    ${ENGINE_CMD} push "${REPO}:${TAG}"

else
    echo "Not pushing since build was triggered by a pull request."
fi
