SOURCES_DIR=src/main/java

echo "Testing Checkstyle started"

cat projects-to-test-on.properties | while read line; do 

    [[ "$line" =~ ^#.*$ ]] && continue # Skip lines with comments
    
    REPO_NAME=`echo $line | cut -d '=' -f 1`
    REPO_URL=`echo $line | cut -d '=' -f 2`
    
    REPO_SOURCES_DIR=$SOURCES_DIR/$REPO_NAME
    
    if [ -d "$REPO_SOURCES_DIR" ]; then
      echo "Pulling repository '$REPO_NAME' ..."
	  cd $REPO_SOURCES_DIR
	  git pull
	  cd -
	  echo "Pulling repository '$REPO_NAME' - successful"
	else
	  echo "Cloning repository '$REPO_NAME' ..."
      git clone $REPO_URL $REPO_SOURCES_DIR
      echo "Cloning repository '$REPO_NAME' - successful"
	fi

done

if [ -d "target" ]; then
  echo "Existing target directory will be cleared"
  rm -rf target/*
else
  mkdir "target"
fi

echo "Running Checkstyle on $SOURCES_DIR ..."

#comment out first line and uncomment second one to run maven in debug
time mvn checkstyle:check "$@" > target/console_log.txt
#time env MAVEN_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y" mvn checkstyle:check "$@" > target/console_log.txt

echo "Running Checkstyle on $SOURCES_DIR - finished"

echo "Testing Checkstyle finished"
