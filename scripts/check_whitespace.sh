#!/bin/bash

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

# Fail on an trailing whitespace characters, excluding
#   * binary files (-I)
#   * nanopb-generated files
#   * protoc-generated files
#
# Note: specifying revisions we care about makes this go slower than just
# grepping through the whole repo.
options=(
  -n  # show line numbers
  -I  # exclude binary files
  ' $'
)

git grep "${options[@]}"

if [[ $? == 0 ]]; then
  echo "ERROR: Trailing whitespace found in the files above. Please fix."
  exit 1
fi
