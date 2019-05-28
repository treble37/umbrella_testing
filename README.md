# KvUmbrella

A test application to test distributed Elixir

#### Build a release locally

-   Use first 2 commands below when troubleshooting; the last 2 commands
    are alternate ways of doing it

      docker build --no-cache -t umbrella_testing .
      docker run -v `pwd`:/opt/umbrella_testing umbrella_testing:latest

      docker build . -t umbrella_testing
      docker run -v `pwd`:/opt/umbrella_testing umbrella_testing:latest -e TIMBER_API_KEY=XXX

#### Exit docker and run the below

    cd _build/prod/rel/kv_umbrella/releases/1.0
    gcloud compute scp kv_umbrella.tar.gz umbrella-testing:~/
    gcloud compute ssh umbrella-testing
    sudo cp ~/kv_umbrella.tar.gz /opt/umbrella_testing/
    cd /opt/umbrella_testing
    sudo tar -zxvf kv_umbrella.tar.gz --overwrite
    sudo bin/kv_umbrella console
