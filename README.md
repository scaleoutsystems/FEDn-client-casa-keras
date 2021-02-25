# CASA test project
This classsic example of Human Daily Activity Recognition (HDAR) is well suited both as a lightweight test when learning FEDn and developing on FEDn in psedo-distributed mode. A normal high-end laptop or a workstation should be able to sustain at least 15 clients. The example is also useful for general scalability tests in fully distributed mode. 

### Provide local training and test data
For large data transfer reason we uploaded a data folder in this use case to archive.org.
To test this use-case you need to download prepared data that composed 27 apartments (casa's), each apartment data are distributed over 11 clients,  using this link:
https://archive.org/download/data_20210225/data.zip
- Unzip the file
- Copy the content of the unzipped Archive to the data folder under casa directory

### Configuring the tests
We have made it possible to configure a couple of settings to vary the conditions for the training. These configurations are expsosed in the file 'client/settings.yaml': 

```yaml 
# Parameters for local training
test_size: 0.25
batch_size: 32
epochs: 3
```

### Creating a compute package
To train a model in FEDn you provide the client code (in 'client') as a tarball (you set the name of the package in 'settings-reducer.yaml'). For convenience, we ship a pre-made package. Whenever you make updates to the client code (such as altering any of the settings in the above mentioned file), you need to re-package the code (as a .tar.gz archive) and copy the updated package to 'packages'. From 'test/casa':

```bash
tar -zcvf casa.tar.gz client
cp casa.tar.gz packages/
```

## Creating a seed model
The baseline LSTM is specified in the file 'client/init_model.py'. This script creates an untrained neural network and serialized that to a file, which is uploaded as the seed model for federated training. For convenience we ship a pregenerated seed model in the 'seed/' directory. If you wish to alter the base model, edit 'client/models/casa_model.py' and regenerate the seed file:

## Generate the configuration files
We provide the 'generate_clients.sh' bash file to generate all the configuration yaml files (docker_compose.clients.yaml, fedn-network.yal, extra-hosts.yaml) to run casa benckmark in the easiest way.



```bash
bash generate_clients.sh 
```

[comment]: <> (## Start the client)

[comment]: <> (The easiest way to start clients for quick testing is by using Docker. We provide a docker-compose template for convenience. First, edit 'fedn-network.yaml' to provide information about the reducer endpoint. Then:)

[comment]: <> (```bash)

[comment]: <> (docker-compose -f docker-compose.yaml up --scale client=2 )

[comment]: <> (```)

[comment]: <> (> Note that this assumes that a FEDn network is running &#40;see separate deployment instructions&#41;. The file 'docker-compose.yaml' is for testing against a local pseudo-distributed FEDn network. Use 'docker-compose.decentralised.yaml' if you are connecting against a reducer part of a distributed setup and provide a 'extra_hosts' file.)

[comment]: <> (The easiest way to start clients for quick testing is by using Docker. We provide a docker-compose template for convenience. First, edit 'fedn-network.yaml' to provide information about the reducer endpoint. Then:)

[comment]: <> (The easiest way to distribute data across client is to start this command instead of the previous one )

[comment]: <> (```bash)

[comment]: <> (docker-compose -f docker-compose.decentralised.yaml up --build)

[comment]: <> (```)


## Configure and start a client using cpu device
The easiest way to start clients for quick testing is to use shell script.The following 
shell script will configure and start a client on a blank Ubuntu 20.04 LTS VM:    


```bash
#!/bin/bash

# Install Docker and docker-compose
sudo apt-get update
sudo sudo snap install docker

# clone the nlp_imdb example
git https://github.com/scaleoutsystems/FEDn-client-casa-keras.git
cd FEDn-client-casa-keras

# if no available data, download it from archive
# wget https://archive.org/download/data_20210225/data.zip
# sudo apt install unzip
# unzip -o data.zip
# sudo rm data.zip

# Make sure you have edited extra-hosts.yaml to provide hostname mappings for combiners
# Make sure you have edited fedn-network.yaml to provide hostname mappings for reducer
sudo docker-compose -f docker-compose.clients.yaml -f extra-hosts.yaml up --build
```

[comment]: <> (### Start prediction- global model serving)

[comment]: <> (We have made it possible to use the trained global model for prediction, to start the UI make sure that the FEDn-network is)

[comment]: <> (is started and run the flask app &#40;python predict/app.py&#41;)

[comment]: <> (```bash)

[comment]: <> (# prediction/)

[comment]: <> (python app.py)

[comment]: <> (```)


## License
Apache-2.0 (see LICENSE file for full information).