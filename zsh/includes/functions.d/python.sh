gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

gpip3(){
   PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

syspip(){
  PIP_REQUIRE_VIRTUALENV="" sudo -H pip "$@"
}