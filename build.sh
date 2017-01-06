#get all submodules
git submodule update --init --recursive

cd ui-service
git fetch
git pull origin master
sh build.sh

cd ../uk-code-service
git fetch
git pull origin master
docker build -t postcoder/uk-code-service .

cd ../eir-code-service
git fetch
git pull origin master
mvn package docker:build

cd ../edge-code-service
git fetch
git pull origin master
mvn package docker:build

cd ../eureka-service
git fetch
git pull origin master
mvn package docker:build

cd ../sidecar-service
git fetch
git pull origin master
mvn package -Dmaven.test.skip=true docker:build

