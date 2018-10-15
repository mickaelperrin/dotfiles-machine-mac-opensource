function exists { which $1 &> /dev/null }

# Generic prompt
ask() {
    # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
    read "?$1 [y/N] " REPLY </dev/tty

    # Default?
    if [ -z "$REPLY" ]; then
        REPLY="n"
    fi

    # Check if the reply is valid
    case "$REPLY" in
        Y*|y*) return 0 ;;
        N*|n*) return 1 ;;
    esac
}