gpip(){
   PIP_REQUIRE_VIRTUALENV="" python -m pip "$@"
}

gpip3(){
   PIP_REQUIRE_VIRTUALENV="" python3 -m pip "$@"
}

syspip(){
  PIP_REQUIRE_VIRTUALENV="" sudo -H pip "$@"
}