# Name of the release
RELEASE_NAME=$1
# Glob pattern to match the assets to be downloaded from the release
ASSETS_PATTERN=$2


if [ -z "${RELEASE_NAME}" ]; then
    echo "ERROR :: Release name is required."
    exit 1;
fi

echo "Downloading release $RELEASE_NAME."

if [ -z "$ASSETS_PATTERN" ]; then
    gh release download $RELEASE_NAME
else
    gh release download $RELEASE_NAME --pattern $ASSETS_PATTERN
fi