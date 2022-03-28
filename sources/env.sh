
if [ "$1" ]; then
    echo Setting $1
    if [ -d "/home/developer/code/$1" ]; then
        export PS1="\e[1;36m[$1]\e[0m \w\a $ "
        export CODE=/home/developer/code
        export PROJ=/home/developer/code/$1
        export TESTSIM=/home/developer/test-sim
        export COMMON=/home/developer/code/common
        alias make='make -f $PROJ/utils/Makefile'
        alias ls='ls -lrpt'
    else
        echo Error: Project $1 not found
    fi
else
    echo Error: command-line no project as argument. Example: source env.sh proj
fi
