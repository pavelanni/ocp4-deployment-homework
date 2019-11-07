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

REPORT_FILE=$1
SIGNED_FILE=$(mktemp /tmp/grading_report_XXXX)
# Cut the headers before the course name
sed '/ocp_adv_infra/,$!d' "$REPORT_FILE" > $SIGNED_FILE
split -l $(($(wc -l < $SIGNED_FILE) - 1)) $SIGNED_FILE
ORIG_FILE=$(awk '{print $2}' xab)
# Remove ^M line endings
sed -i -e "s///" xaa
mv xaa $ORIG_FILE
# Check if there are FAILs in the report
if grep -q FAIL $ORIG_FILE ; then
    head -3 $ORIG_FILE
    echo "FAILED"
    echo ""
    exit 1
fi
# Check the checksum
if $SHA_COMMAND --quiet -c xab ; then
    head -3 $ORIG_FILE
    echo "PASSED"
    echo ""
else
    head -3 $ORIG_FILE
    echo "FAILED"
    echo ""
fi

rm $SIGNED_FILE
rm xab
