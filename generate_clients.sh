#!/bin/bash

casa_numbers=27   # min =1, max =27
client_numbers=10 #max= 10 , starts from 0
reducer_host='reducer'
combiner_name='combiner'
combiner_ip='130.238.20.10'

clients_counter=1
 echo "Generate docker-compose.clients.yaml file"
 {
    printf "version: '3.3'\n"; shift
    printf 'services:\n'; shift

    for (( casa=1; casa<=$casa_numbers; casa++ ))
    do

      for (( client=0; client<=$client_numbers; client++ ))
      do
        printf "  client$clients_counter:\n"; shift
        printf '    environment:\n'; shift
        printf '      - GET_HOSTS_FROM=dns\n'; shift
        printf '    image: "scaleoutsystems/casa-client:latest"\n'; shift
        printf '    build:\n'; shift
        printf '      context: .\n'; shift
        printf '    working_dir: /app\n'; shift
        printf '    command: /bin/bash -c "fedn run client -in fedn-network.yaml"\n'; shift
        printf '    volumes:\n'; shift
        printf "      - ./data/casa$casa/c$client:/app/data\n"; shift
        ((++clients_counter))

      done

    done

    printf "networks:\n"; shift
    printf "  default:\n"; shift
    printf "    external:\n"; shift
    printf "      name: fedn_default\n"; shift

}  >docker-compose.clients.yaml



    echo "Generate fedn-network.yaml file"
    {
        printf "network_id: fedn-test-network\n"; shift
        printf "controller:\n"; shift
        printf "    discover_host: $reducer_host\n"; shift
        printf "    discover_port: 8090\n"; shift
        printf "    token: token \n \n"; shift
    } >fedn-network.yaml



    ### Generate extra-hosts-client.yaml file
    echo "Generate extra-hosts.yaml file"
    {
      printf "version: '3.3'\n"; shift
      printf 'services:\n'; shift

      for (( client=1; client<$clients_counter; client++ ))
       do

        printf "   client$client:\n"; shift
        printf '    extra_hosts:\n'; shift
        printf '      %s: %s \n' "$combiner_name" "$combiner_ip"

      done
    } > extra-hosts.yaml


