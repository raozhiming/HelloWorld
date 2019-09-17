
# skip submodule:ToolChains
# skip commit with ci-skip or skip-ci
# since one day ago

# HOST="$(uname -s)"

# case "${HOST}" in
#     "Darwin")
#         STRIP_ARG="--strip-components=1"
#         ;;
#     "Linux")
#         STRIP_ARG="--strip-components 1"
#         ;;
#     *)
#         echo "Error: Unsupported platform"
#         exit 1;;
# esac

TAG_DATE=0
# Get latest tag name
LatestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
if [ "$LatestTag" != "" ]; then
    TAG_DATE=`git log -1 --format=%ct $LatestTag`
fi


# date -d @$TAG_DATE
LastestTagDate=`date -r $TAG_DATE`
echo "LastestTag Date:"$LastestTagDate

git submodule foreach "
if [ \"$path\" = \"ToolChains\" ]; then
    return 0
else
    if
        git log --since=\"$LastestTagDate\" --grep=\"ci-skip\" --grep=\"skip-ci\" --invert-grep -i | grep Author
    then
        echo \"find commit\"
        return 1
    fi
fi
"
