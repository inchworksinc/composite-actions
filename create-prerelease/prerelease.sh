# Name of the release
RELEASE_NAME=$1
# Branch name to target
BRANCH_NAME=$2
# Zip file containing the release artifacts
ARTIFACTS_ZIP=$3

echo "Creating release $RELEASE_NAME."
CREATE_RELEASE_STATUS=$(gh release create $RELEASE_NAME --title v$RELEASE_NAME --target $BRANCH_NAME --prerelease 2>&1)
if [[ $CREATE_RELEASE_STATUS == *"422"* ]]; then
    echo "CREATE_RELEASE_STATUS: $CREATE_RELEASE_STATUS"
    echo "ERROR :: Release $RELEASE_NAME already exists."
    exit 1;
else
    echo "Adding $RELEASE_NAME artifact(s)."
    gh release upload $RELEASE_NAME $ARTIFACTS_ZIP
    echo "Creating release notes"
    LATEST_RELEASE_TAG=$(gh release list --exclude-drafts --exclude-pre-releases --json isLatest,tagName --jq '.[]| select(.isLatest)|.tagName')
    if [ -z "${LATEST_RELEASE_TAG}" ];then
        LOG=$(git log $BRANCH_NAME --pretty=format:"%s by %aN in %h" --no-merges)
    else
        LOG=$(git log $LATEST_RELEASE_TAG..$BRANCH_NAME --pretty=format:"%s by %aN in %h" --no-merges)
    fi
    echo "Latest release tag $LATEST_RELEASE_TAG"
    echo "$LOG">release-notes.log
    LOG_CHARACTERS_COUNT=$(wc -c< release-notes.log)
    if [[ "${LOG_CHARACTERS_COUNT}" -gt 125000 ]]; then
        echo "Release notes character count exceeds Github releases maximum. Adding as attachement"
        gh release edit $RELEASE_NAME --notes 'Release notes added as attachment - release-notes.log'
        gh release upload $RELEASE_NAME release-notes.log
    else
        gh release edit $RELEASE_NAME --notes-file release-notes.log
    fi
fi