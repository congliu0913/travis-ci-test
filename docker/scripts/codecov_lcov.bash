#!/bin/bash

set -e

if [ -d build ];then
  echo "please run this script from your workspace."
  exit 1
fi

LCOVDIR=lcov
PWD=`pwd`

mkdir -p $LCOVDIR
# Generate initial zero-coverage data. This adds files that were otherwise not run to the report
lcov -c  --initial --rc lcov_branch_coverage=1 --directory build --output-file ${LCOVDIR}/initialcoverage.info

# Capture executed code data.
lcov -c --rc lcov_branch_coverage=1 --directory build --output-file ${LCOVDIR}/testcoverage.info

# Combine the initial zero-coverage report with the executed lines report
lcov -a ${LCOVDIR}/initialcoverage.info -a ${LCOVDIR}/testcoverage.info --rc lcov_branch_coverage=1 --o ${LCOVDIR}/fullcoverage.info

# Only include files that are within this workspace (eg filter out stdio.h etc)
lcov -e ${LCOVDIR}/fullcoverage.info "${PWD}/*" --rc lcov_branch_coverage=1 --output-file ${LCOVDIR}/workspacecoverage.info

# Remove files in the build subdirectory because they are generated files (like messages, services, etc)
lcov -r ${LCOVDIR}/workspacecoverage.info "${PWD}/build/*" "${PWD}/install/cv_bridge/*" "${PWD}/install/object_msgs/*" --rc lcov_branch_coverage=1 --output-file ${LCOVDIR}/projectcoverage.info

bash <(curl -s https://codecov.io/bash) -f ${LCOVDIR}/projectcoverage.info
