#!/bin/bash
# 05_test_all.sh
# Maintainer: jia.jun@deriv.com
bail() {
    echo "$1" >&2;
    exit 1;
}
expand_path() {
    if [ -d "$1" ]; then
        echo $(bash -c "cd \"$1\" && pwd");
    else
        echo $(bash -c "cd \"$(dirname $1)\" && pwd");
    fi
}
DIR=${1:-$(pwd)};
OVERIDDEN_IMAGE_NAME=$2;

if [ $DIR == '--exec-inner' ]; then
    # Inner suite
    for FILE in $(find . -type f -name '*.pm'); do
        ROOT=$(expand_path $(which $0));
        #perl -cw -I/app/lib -MMyriad $FILE || bail "Check failed for the file $FILE";
        # Guess the module name
        REGEX="^\s*package\s+([a-zA-Z0-9\:]*[a-zA-Z0-9])\s*\;";
        export MODULE_TO_LOAD=$(grep -v -E '^#' $FILE | head -n 1 | grep --only-matching -E "$REGEX" | sed -E "s/$REGEX/\1/");
        prove -I/app/lib -MMyriad -v "$ROOT/../share/01_syntax.t" || bail "Check failed for the file $FILE";
    done
    if [ -d "/app/t" ]; then
        prove -I/app/lib -MMyriad -vr "/app/t";
    fi
    exit 0;
else
    echo "Starting test suite in $DIR";
    if [ ! -d "$DIR/lib/" ]; then
        bail  "Cannot find $DIR/lib/, exitting";
    fi
    if [ "$TOOLCHAIN" == 'docker-standalone' ]; then
        ([ -f "cpanfile" ] || [ -f "aptfile" ]) && prepare-apt-cpan.sh;
        export PERL5LIB="$(pwd)/lib"
        $0 --exec-inner
        exit $?;
    fi
    which docker > /dev/null || bail "cannot find docker! Exitting";

    IMAGE_NAME='deriv/myriad:latest';

    # Rebuild the image if there is a Dockerfile there
    if [ -f "$DIR/Dockerfile" ]; then
        IMAGE_NAME=$(mktemp -u ci/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | tr '[:upper:]' '[:lower:]');
        IMAGE_NAME=${OVERIDDEN_IMAGE_NAME:-$IMAGE_NAME};
        echo "Dockerfile present, building it as $IMAGE_NAME";
        docker build  "$DIR" -t $IMAGE_NAME || bail "Cannot build image! Exitting";
    fi

    # Create the image and actually run it
    docker run --rm -v $(expand_path $DIR):/app/ -v "$(expand_path $(which $0))/../":/ci-tools  --entrypoint /bin/bash $IMAGE_NAME -c \
            'cd /app && /ci-tools/bin/05_test_all.sh --exec-inner'
    RET=$?
    # Cleanup if it is auto regenerated
    [ -f "$DIR/Dockerfile" ] && [ "$IMAGE_NAME" != "$OVERIDDEN_IMAGE_NAME" ] && docker image rm $IMAGE_NAME;
    exit $RET;
fi
