#!/usr/bin/env bash

BASE="$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)"

"${BASE}/build.sh" Minimal
"${BASE}/build.sh" MinimalUnix