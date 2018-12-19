#! /bin/bash

TMP=/tmp
#PRUNE="-name .svn -prune -o -name .git -prune -o -name libs -prune -o -name build -type d -prune -o -name docs -prune"
PRUNE="-name .svn -prune -o -name .git -prune -o -name build -type d -prune -o -name docs -prune"
GREPV=\(\.svn\|\.git\|^docs$\|^libs$\|^build\|^moc_\|^qrc_\|^ui_\|^Install\|juce_amalgamated.*\)
find `pwd` \( -iname "*.inl" -o -iname "*.h" -o -iname "*.hxx" -o -iname "*.hpp" -o ${PRUNE} \) -size +0 -print | grep -Eiv '${GREPV}' > $TMP/cfiles.txt
find `pwd` \( -iname "*.cpp" -o -iname "*.cxx" -o -iname "*.cc" -o -iname "*.c" -o ${PRUNE} \) -size +0 -print | grep -Eiv '${GREPV}' >> $TMP/cfiles.txt
find `pwd` \( -iname "*.lm" -o -iname "*.m" -o -iname "*.mm" -o ${PRUNE} \) -size +0 -print | grep -Eiv '${GREPV}' > $TMP/objcfiles.txt
find `pwd` \( -iname "*.java" -o -iname "*.pde" -o -iname "*.el" -o -iname "*.py" -o ${PRUNE} \) -size +0 -print | grep -Eiv '${GREPV}' > $TMP/files.txt
find `pwd` \( -iname "*.cs" -o -iname "*.ch" -o ${PRUNE} \) -size +0 -print | grep -Eiv '${GREPV}' > $TMP/csfiles.txt
if [[ "${1}" == "-web" ]]; then
    find `pwd` \( -iname "*.php" -o -iname "*.css" -o -iname "*.xml" -o -iname "*.phtml" -o -iname "*.html" -o -iname "*.htm" -o -iname "*.shtml" -o ${PRUNE} \) -size +0 -print | grep -Eiv '${GREPV}' > $TMP/webfiles.txt
fi
