#!/usr/bin/env bash
set -e
TEAM_SESSION_KEY=
MY_SESSION_KEY=
ACTION=${1:-in}

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
  fi
}

cleanup() {
  find ${TMPDIR:-/tmp} -maxdepth 1 -name "opsessions.*" -print0 | xargs -0 ls -1 -t | tail -n +2 | xargs /bin/rm
}

function op_signin() {
  TEAM_SESSION_KEY=$(op signin --account $OP_TEAM_SHORTHAND -f --raw)
  MY_SESSION_KEY=$(op signin --account my -f --raw)
}

function op_signout() {
  if [[ -f "$OP_SESSIONSHARING_FILE" ]]; then
    /bin/rm "$OP_SESSIONSHARING_FILE"
  fi
  op signout
  echo "export OP_SESSION_$(getUserUUIDFromShortHand $OP_TEAM_SHORTHAND)="
  echo "export OP_SESSION_$(getUserUUIDFromShortHand my)="
}

function getUserUUIDFromShortHand() {
  jq  ".accounts[]|select(.shorthand==\"$1\") | .userUUID" < ~/.op/config
}

function persistSessionKeys() {
  echo "export OP_SESSION_$(getUserUUIDFromShortHand $OP_TEAM_SHORTHAND)=${TEAM_SESSION_KEY}"
  echo "export OP_SESSION_$(getUserUUIDFromShortHand my)=${MY_SESSION_KEY}"
}

function getSessionSharingFile() {
  find ${TMPDIR:-/tmp} -maxdepth 1 -name "opsessions.*" -print0 | xargs -0 ls -1 -t | head -1
}

function get1PasswordSession() {
  if [[ -z "$OP_SESSIONSHARING_FILE" ]]; then
    OP_SESSIONSHARING_FILE=$(getSessionSharingFile)
  fi
  if [[ "$(isAuthenticatedOnGPG)" == "1" ]] && [[ ! -z "$OP_SESSIONSHARING_FILE" ]] && [[ -f "$OP_SESSIONSHARING_FILE" ]] && [[ $(gstat --printf="%s" $OP_SESSIONSHARING_FILE) != "0" ]]; then
    gpg --quiet --decrypt "$OP_SESSIONSHARING_FILE"
  fi
}

function isAuthenticatedOnGPG() {
  gpg-connect-agent 'keyinfo --list' /bye 2>/dev/null | awk "BEGIN{CACHED=0} /^S KEYINFO $MY_GPG_PRIVATE_KEYGRIP/ {if(\$7==1){CACHED=1}} END{if(\$0!=\"\"){print CACHED} else {print \"none\"}}"
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