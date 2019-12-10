printf "\n\nVersions check\n"
printf "$(ls /Library/Java/JavaVirtualMachines/)" 
java --version

printf "\n\nInstall JDK 8\n"
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk8

printf "\n\nVersions check\n"
printf "$(ls /Library/Java/JavaVirtualMachines/)" 
java --version

printf "\n\nInstall Scala\n"
brew install scala

printf "\n\nInstall SBT\n"
brew install sbt
sbt --version

printf "\n\nClone repos\n"
git clone https://github.com/snowplow-incubator/snowplow-micro.git micro
git clone https://github.com/snowplow/snowplow.git stream
pushd stream
git checkout scala_stream_collector/0.15.0

printf "\n\nPublish Stream collector\n"
cd ./2-collectors/scala-stream-collector
sbt --batch --verbose --java-home /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home sbtVersion
sbt --batch --verbose --java-home /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home publishLocal
popd

printf "\n\nRun Micro\n"
cd micro
sbt --batch --verbose --java-home /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home sbtVersion
sbt --batch --java-home /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home "run --collector-config ./example/micro.conf --iglu ./example/iglu.json" 1>&1 &
