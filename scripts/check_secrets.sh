#!/bin/sh

# Copyright 2025 Harrison Cho
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Check if secrets are available

set -x
echo "GITHUB_BASE_REF: ${GITHUB_BASE_REF:-}"
echo "GITHUB_HEAD_REF: ${GITHUB_HEAD_REF:-}"

check_secrets()
{
  # GitHub Actions: Secrets are available if we're not running on a fork.
  # See https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
  # TODO- Both GITHUB_BASE_REF and GITHUB_HEAD_REF are set in master repo
  # PRs even thought the docs say otherwise. They are not set in cron jobs on master.
  # Investigate how do to distinguish fork PRs from master repo PRs.
  if [[ -n "${GITHUB_WORKFLOW:-}" ]]; then
    return 0
  fi
  return 1
}
