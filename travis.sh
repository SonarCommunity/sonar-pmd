#!/bin/bash

set -eo pipefail

case "$TEST" in

ci)
  mvn clean test sonar:sonar -DskipTestProjects=true
  ;;

plugin)

  # Unset environment settings defined by Travis that will collide with our integration tests
  unset SONARQUBE_SCANNER_PARAMS SONAR_TOKEN SONAR_SCANNER_HOME

  # Run integration tests
  mvn verify -Dtest.sonar.version=${SQ_VERSION} -Dtest.sonar.plugin.version.java=${SJ_VERSION} -Dorchestrator.artifactory.url=https://repox.jfrog.io/repox
  ;;

javadoc)
    # Create JavaDocs to check for problems with JavaDoc generation
    mvn install javadoc:javadoc -DskipTests
    ;;

*)
  echo "Unexpected TEST mode: $TEST"
  exit 1
  ;;

esac
