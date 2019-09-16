#!/usr/bin/env bash
if [ "$#" -eq 0 ];
then
  echo "Usage: $0 <file_to_verify>"
  exit 1
fi
  
if [ $(uname) = "Darwin" ]; then
    SHA_COMMAND="shasum -a 256"
else
    SHA_COMMAND="sha256sum"
fi

echo $SHA_COMMAND

SIGNED_FILE=$1
split -l $(($(wc -l < $SIGNED_FILE) - 1)) $SIGNED_FILE
ORIG_FILE=$(awk '{print $2}' xab)
mv xaa $ORIG_FILE
if $SHA_COMMAND --quiet -c xab ; then
    head -3 $ORIG_FILE
    echo "PASSED"
    echo ""
else
    head -3 $ORIG_FILE
    echo "FAILED"
    echo ""
fi

