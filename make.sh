#!/bin/bash
# shellcheck disable=SC2154,SC2059


DOC="
Make script

Helpful commands to work with this project.

Usage:
  ./make (setup|update)
  ./make admin
  ./make admin [--] COMMAND [ARGS...]
  ./make (build|test|clean)
  ./make deploy (--dev|--test|--release)
  ./make lint [--check]

Options:
  -h, --help      Prints this help text
  -c, --check     Checks the lint instead of changing code
  -d, --dev       Deploys a dev egg
  -t, --test      Deploys a test egg
  -r, --release   Deploys a release egg
"

# docopt parser below, refresh this parser with `docopt.sh make`
# shellcheck disable=2016,1090,1091,2034,2154
docopt() { source admin/docopt.sh '0.9.17' || { ret=$?
printf -- "exit %d\n" "$ret"; exit "$ret"; }; set -e; trimmed_doc=${DOC:1:456}
usage=${DOC:59:176}; digest=a9e73; shorts=(-d -t -r -c)
longs=(--dev --test --release --check); argcounts=(0 0 0 0); node_0(){
switch __dev 0; }; node_1(){ switch __test 1; }; node_2(){ switch __release 2; }
node_3(){ switch __check 3; }; node_4(){ value COMMAND a; }; node_5(){
value ARGS a true; }; node_6(){ _command setup; }; node_7(){ _command update; }
node_8(){ _command admin; }; node_9(){ _command __ --; }; node_10(){
_command build; }; node_11(){ _command test; }; node_12(){ _command clean; }
node_13(){ _command deploy; }; node_14(){ _command lint; }; node_15(){
either 6 7; }; node_16(){ required 15; }; node_17(){ required 16; }; node_18(){
required 8; }; node_19(){ optional 9; }; node_20(){ oneormore 5; }; node_21(){
optional 20; }; node_22(){ required 8 19 4 21; }; node_23(){ either 10 11 12; }
node_24(){ required 23; }; node_25(){ required 24; }; node_26(){ either 0 1 2; }
node_27(){ required 26; }; node_28(){ required 13 27; }; node_29(){ optional 3
}; node_30(){ required 14 29; }; node_31(){ either 17 18 22 25 28 30; }
node_32(){ required 31; }; cat <<<' docopt_exit() {
[[ -n $1 ]] && printf "%s\n" "$1" >&2; printf "%s\n" "${DOC:59:176}" >&2; exit 1
}'; unset var___dev var___test var___release var___check var_COMMAND var_ARGS \
var_setup var_update var_admin var___ var_build var_test var_clean var_deploy \
var_lint; parse 32 "$@"; local prefix=${DOCOPT_PREFIX:-''}
unset "${prefix}__dev" "${prefix}__test" "${prefix}__release" \
"${prefix}__check" "${prefix}COMMAND" "${prefix}ARGS" "${prefix}setup" \
"${prefix}update" "${prefix}admin" "${prefix}__" "${prefix}build" \
"${prefix}test" "${prefix}clean" "${prefix}deploy" "${prefix}lint"
eval "${prefix}"'__dev=${var___dev:-false}'
eval "${prefix}"'__test=${var___test:-false}'
eval "${prefix}"'__release=${var___release:-false}'
eval "${prefix}"'__check=${var___check:-false}'
eval "${prefix}"'COMMAND=${var_COMMAND:-}'
if declare -p var_ARGS >/dev/null 2>&1; then
eval "${prefix}"'ARGS=("${var_ARGS[@]}")'; else eval "${prefix}"'ARGS=()'; fi
eval "${prefix}"'setup=${var_setup:-false}'
eval "${prefix}"'update=${var_update:-false}'
eval "${prefix}"'admin=${var_admin:-false}'
eval "${prefix}"'__=${var___:-false}'
eval "${prefix}"'build=${var_build:-false}'
eval "${prefix}"'test=${var_test:-false}'
eval "${prefix}"'clean=${var_clean:-false}'
eval "${prefix}"'deploy=${var_deploy:-false}'
eval "${prefix}"'lint=${var_lint:-false}'; local docopt_i=1
[[ $BASH_VERSION =~ ^4.3 ]] && docopt_i=2; for ((;docopt_i>0;docopt_i--)); do
declare -p "${prefix}__dev" "${prefix}__test" "${prefix}__release" \
"${prefix}__check" "${prefix}COMMAND" "${prefix}ARGS" "${prefix}setup" \
"${prefix}update" "${prefix}admin" "${prefix}__" "${prefix}build" \
"${prefix}test" "${prefix}clean" "${prefix}deploy" "${prefix}lint"; done; }
# docopt parser above, complete command for generating this parser is `docopt.sh --library=admin/docopt.sh make`

DOCOPT_DOC_CHECK=false
eval "$(docopt "$@")"

set -euo pipefail
ADMIN_IMAGE=datascience-models-admin

function build_admin
{
  docker build -f admin/Dockerfile -t "$ADMIN_IMAGE" .
}

function run_admin
{
  local volume_option=""
  if [ -z "${IS_JENKINS:-}" ]; then
    # shellcheck disable=SC2089
    volume_option="-v $(pwd):/workspace"
  fi

  # shellcheck disable=SC2090,2086
  command docker run --rm \
    $volume_option "$ADMIN_IMAGE" \
    "$@"
}

function admin
{
  if [ -n "${COMMAND:-}" ]; then
    if [ -n "${ARGS:-}" ]; then
      run_admin ./make "$COMMAND" "${ARGS[@]}"
    else
      run_admin ./make "$COMMAND"
    fi
  else
    echo -e "=== Building image\n"
    build_admin
    echo -e "\n=== Running container"

    if [ -z "${DATABRICKS_API_TOKEN:-}" ] && [ -z "${DATABRICKS_TOKEN:-}" ]; then
      cat << 'EOF'

See https://docs.databricks.com/dev-tools/api/latest/authentication.html. Make
sure you have DATABRICKS_TOKEN setup locally:

    export DATABRICKS_API_TOKEN=<token>
    export DATABRICKS_TOKEN=<token>

See https://docs.databricks.com/dev-tools/api/latest/authentication.html.
Alternatively, if you have LDC tools setup, run:

    eval "$(rdb secrets)"
EOF
      exit 1
    fi

    docker run -it --rm \
      --env "DATABRICKS_HOST=${DATABRICKS_HOST:-https://riotgames.cloud.databricks.com/}" \
      --env "DATABRICKS_TOKEN=${DATABRICKS_TOKEN:-}" \
      --env "DATABRICKS_ADDRESS=${DATABRICKS_ADDRESS:-https://riotgames.cloud.databricks.com/}" \
      --env "DATABRICKS_API_TOKEN=${DATABRICKS_API_TOKEN:-}" \
      --env "DATABRICKS_CLUSTER_ID=${DATABRICKS_CLUSTER_ID:-1019-223546-plunk409}" \
      --env "DATABRICKS_ORG_ID=${DATABRICKS_ORG_ID:-0}" \
      --env "DATABRICKS_PORT=${DATABRICKS_PORT:-15001}" \
      -v "$(pwd):/workspace" "$ADMIN_IMAGE"
  fi
}

function clean
{
  ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

  ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

  ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache
}

if $setup; then
  build_admin
elif $update; then
  run_admin docopt.sh --library admin/docopt.sh make
elif $admin; then
  admin
elif $test; then
  clean
  python setup.py bdist_egg

  echo -e "\nRunning tests..."
  pytest tests/
elif $lint; then
  if "$__check"; then
    echo "Linting datascience_models"
    python3 -m black --line-length 88 --diff datascience_models

    echo -e "\nLinting tests"
    python3 -m black --line-length 88 --diff tests
  else
    echo "Linting datascience_models"
    python3 -m black --line-length 88 datascience_models

    echo -e "\nLinting tests"
    python3 -m black --line-length 88 tests
  fi
elif $clean; then
  clean
elif $build; then
  clean
  python setup.py bdist_egg
	ls -l dist
elif $deploy; then
  python setup.py bdist_egg

  echo -e "\nDeploying..."
  if $__dev; then
    dbfs cp dist/datascience_models-*.egg dbfs:/FileStore/ldc/libs/python/datascience_models/datascience_models-dev-latest.egg --overwrite
    echo "Successfully deployed dev"
  elif $__test; then
    dbfs cp dist/datascience_models-*.egg dbfs:/FileStore/ldc/libs/python/datascience_models/datascience_models-test-latest.egg --overwrite
    echo "Successfully deployed test"
  elif $__release; then
    dbfs cp dist/datascience_models-*.egg dbfs:/FileStore/ldc/libs/python/datascience_models/datascience_models-latest.egg --overwrite
    echo "Successfully deployed release"
  fi
fi
