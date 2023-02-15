#!/usr/bin/env bash
set -e
TEAM_SESSION_KEY=
MY_SESSION_KEY=
ACTION=${1:-in}
OP_CONFIG_FILE=$HOME/.config/op/config
if [ ! -f "$OP_CONFIG_FILE" ]; then
  OP_CONFIG_FILE=$HOME/.op/config
  if [ ! -f "$OP_CONFIG_FILE" ]; then
    echo "Unable to locate OP config file ~/.op/config"
    exit 1
  fi
fi

function has_personal_account() {
  test "$(cat $OP_CONFIG_FILE  | jq '.accounts|map(select(.shorthand=="my"))|length')" = "1" && return 0 || return 1
}

function checks() {
  if ! which op > /dev/null; then
    echo "1Password CLI (op) is not installed."
    exit 1
  fi

  if [[ -z "$MY_GPG_PUBLIC_ID" ]]; then
    echo "MY_GPG_PUBLIC_ID environment variable missing"
    exit 1
  fi

  if [[ -z "$OP_TEAM_SHORTHAND" ]]; then
    echo "OP_TEAM_SHORTHAND environment variable missing"
    exit 1
  fi

  if [[ -z "$OP_SESSIONSHARING_FILE" ]]; then
    mktemp -t opsessions > /dev/null
    OP_SESSIONSHARING_FILE=$(getSessionSharingFile)
  fi
}

cleanup() {
  find "${TMPDIR:-/tmp}" -maxdepth 1 -name "opsessions.*" -print0 | xargs -0 ls -1 -t | tail -n +2 | xargs /bin/rm
}

function op_signin() {
  TEAM_SESSION_KEY=$(op signin --account "$OP_TEAM_SHORTHAND" -f --raw)
  if has_personal_account; then
    MY_SESSION_KEY=$(op signin --account my -f --raw)
  fi
}

function op_signout() {
  if [[ -f "$OP_SESSIONSHARING_FILE" ]]; then
    /bin/rm "$OP_SESSIONSHARING_FILE"
  fi
  op signout
  echo "export OP_SESSION_$(getUserUUIDFromShortHand "$OP_TEAM_SHORTHAND")="
  if has_personal_account; then
    echo "export OP_SESSION_$(getUserUUIDFromShortHand my)="
  fi
}

function getUserUUIDFromShortHand() {
  jq  ".accounts[]|select(.shorthand==\"$1\") | .userUUID" < "$OP_CONFIG_FILE" | tr -d '"'
}

function persistSessionKeys() {
  echo "export OP_SESSION_$(getUserUUIDFromShortHand "$OP_TEAM_SHORTHAND")=\"${TEAM_SESSION_KEY}\""
  if has_personal_account; then
    echo "export OP_SESSION_$(getUserUUIDFromShortHand my)=\"${MY_SESSION_KEY}\""
  fi
}

function getSessionSharingFile() {
  find "${TMPDIR:-/tmp}" -maxdepth 1 -name "opsessions.*" -print0 | xargs -0 ls -1 -t | head -1
}

function get1PasswordSession() {
  if [[ -z "$OP_SESSIONSHARING_FILE" ]]; then
    OP_SESSIONSHARING_FILE=$(getSessionSharingFile)
  fi

  if $(isAuthenticatedOnGPG) && [[ -n "$OP_SESSIONSHARING_FILE" ]] && [[ -f "$OP_SESSIONSHARING_FILE" ]] && [[ $(gstat --printf="%s" "$OP_SESSIONSHARING_FILE") != "0" ]]; then
    gpg --quiet --decrypt "$OP_SESSIONSHARING_FILE"
  fi
}

function isAuthenticatedOnGPG() {
  gpg-connect-agent 'keyinfo --list' /bye 2>/dev/null | awk "BEGIN{CACHED=0} /^S KEYINFO $MY_GPG_PRIVATE_KEYGRIP/ {if(\$7==1){CACHED=1}} END{if(\$0!=\"\"){print CACHED} else {print \"none\"}}" > /dev/null
}

# Only exec if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  OP_SESSIONSHARING_FILE=$(getSessionSharingFile)
  checks
  cleanup

  if [[ "$ACTION" == "in" ]]; then
    op_signin
    persistSessionKeys | gpg --encrypt --batch --yes --quiet --recipient "$MY_GPG_PUBLIC_ID" --output "$OP_SESSIONSHARING_FILE"
    persistSessionKeys
  elif  [[ "$ACTION" == "update" ]]; then
    get1PasswordSession
  else
    op_signout
  fi
fi

# Required as it is sourced and following scripts may have errors
set +e