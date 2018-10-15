#auto gulp
u() {
  if ! gulp 2>&1 >/dev/null ; then
    gulp --gulpfile ${PROJECT_PATH}/src/gulpfile.js "$@"
  else
     gulp "$@"
  fi
}