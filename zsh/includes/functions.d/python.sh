gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

syspip(){
  PIP_REQUIRE_VIRTUALENV="" sudo -H pip "$@"
}