FILES_PATTERN='*.rb'
FORBIDDEN='debugger'
find . -name $FILES_PATTERN | \
    GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n $FORBIDDEN && echo 'COMMIT REJECTED Found "debugger" references. Please remove them before commiting OR use --no-verify option for git commit' && exit 1
