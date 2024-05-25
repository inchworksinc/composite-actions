# Name of the release
RELEASE_NAME=$1
# The directory to download files into
DIRECTORY=$2
# Glob pattern to match the assets to be downloaded from the release
ASSETS_PATTERN=$3
# GitHub repository
REPOSITORY=$4

if [ -z "${RELEASE_NAME}" ]; then
    echo "ERROR :: Release name is required."
    exit 1;
fi

if [ -z "${REPOSITORY}" ]; then
    echo "ERROR :: Repository is required."
    exit 1;
fi

echo "Downloading release $RELEASE_NAME from $REPOSITORY to $DIRECTORY."

if [ -z "$ASSETS_PATTERN" ]; then
    gh release download $RELEASE_NAME --dir $DIRECTORY --repo $REPOSITORY
else
    gh release download $RELEASE_NAME --dir $DIRECTORY --pattern $ASSETS_PATTERN --repo $REPOSITORY
fi