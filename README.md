# hadoop-docker
Example of local hadoop docker. Background is there no official well setup local hadoop docker. Write this example to build from official image and setup all necessary steps.



<!-- USAGE EXAMPLES -->
## Usage
After build docker image and run docker container, can cast hdfs command at container and check HDFS web UI on host http://localhost:9870/.  

```sh
# Run docker container with enough memory and expose web UI
docker run -it \
  -p 9870:9870 \
  -p 9000:9000 \
  --hostname localhost \
  --memory=6g \
  --memory-swap=6g \
  hadoop-local:3.4.0_v1 bash
  

# Setup ssh daemon
nohup sudo /usr/sbin/sshd &
# Format HDFS NameNode
hdfs namenode -format
# Launch 
bash /opt/hadoop/sbin/start-dfs.sh

# Testing HDFS client command
hdfs dfs -mkdir /user/hadoop
hdfs dfs -ls /
```

## How to build
```sh
# Build docker image
docker build -t hadoop-local:3.4.0_v1 .
```

## FAQ
| No | Question                                                                                                       | Answer                                                                          |
|----|----------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| 1  | Segmentation fault (core dumped)                                                                               | Increase docker <br/>--memory to 6 GB   --memory=6g --memory-swap=6g            |
| 2  | namenode constantly exit without error message                                                                 | Same as Q1                                                                      |
| 3  | hdfs client command hang<br/> top H shows two occupy CPU 100%. How to fix? <br/>VM Thread and IPC Server hand. | core-site.xml set wrong port for fs.defaultFS, older version:9000, hadoop3=8020 |


