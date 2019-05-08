# KvUmbrella

**TODO: Add description**

#### Build a release locally

    docker build . -t umbrella_testing
    docker build --no-cache -t umbrella_testing .
    docker run -v `pwd`:/opt/umbrella_testing umbrella_testing:latest -e TIMBER_API_KEY=XXX
