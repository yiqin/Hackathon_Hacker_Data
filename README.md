# Hackathon_Hacker_Data
http://104.197.20.219/yiqin/facebook_hackathon_hacker.html

# Project Description

We get the data from Facebook using Facebook Graph API. The dataset are from about Hackathon Hackers (HH), which has become the biggest Facebook group for hackathon attendees. Currently, it has over 18k members. It's a place to discuss hackathons, tech news, college, high school, and dank memes. It had 53 different public subgroups. One of hbase tables I built is to get the top 20 active users in most 25 popular subgroups.

Facebook limits developers to any public graph data at Facebook due to the privary. This dataset in csv file is 245.5 MB. The time range is from 7/1/2014 - 8/20/2015, which is more than one year. This is the larget dataset I could get from Facebook Graph API. It has more than 1,300,000 items. It includes information about members' likes, comments and posts. 


# Files
I upload all files to svn. These files are also upoad to different directory in the cluster.

## hadoop-m:/mnt/scratch/yiqin
- create_Facebook_Graph_Data_Table.pig  
  To create the hbase table for the most popular subgroup.

- top_user.pig
  To create the hbase table for the top active users in each subgroup. I use macro to reused code.

- general_information.pig
  To create other information. These parts are not stored into hbase table due to time limit. It includes Types count, Like ranking, and Likes and comments average.

- uber-yiqin-0.0.1-SNAPSHOT.jar
  Java application. It includes Thrift and SerializeFacebookGraphNode. 

- input
  Includes .csv files, which are raw data from Facebook Graph API.


## hadoop fs -ls /mnt/scratch/yiqin
Found 1 items
-rw-r--r--   2 mpcs53013 hdfs  212250910 2015-12-08 04:46 /mnt/scratch/yiqin/Facebook_Graph_data


## webserver:/var/www/html/yiqin
- background.jpeg
- elegant-aero.css  
- table.css
  These three files are for UI element in html.

- facebook_hackathon_hacker.html  
  html file used for the url. It includes three parts: most popular subgroup, top active users, and submitting new Facebook grasph node data.


## webserver:/var/www/cgi-bin/yiqin
- facebook_Graph_Data_Table.pl
  To get the hbase table of most popular subgroups.

- top_user.pl
  To get the hbase table of top active users.

- submit_new_data.pl  
  To send new data to kafka.


## kafka topic
  I have created a topic yiqin-facebook on kafka.


###############################################
## Other information
## Mainly for me to review the project, not for grading
## Please ignore it.
###############################################

# Current Progress
The batch layer is ready. ```csv``` dataset are uploaded ```/mnt/scratch/yiqin/input``` in the cluster. facebookGraphNode.thrift is created to process the data. ```uber-yiqin-0.0.1-SNAPSHOT.jar``` is also in the cluster. ```create_Facebook_Graph_Data_Table.pig``` is to create the table and show the table. You can see the data are stored.

Facebook graph data are so difficult to deal with, but contain interesting information. I'm going to finish the project in the next 4 days.


## Subgroup
Subgroup must satisfy one of these prerequisites:
- 1 week old, 5 posts, and 250 members
- 3 weeks old, 10 posts, and 100 members

(Hackathon Hackers,522870)
(HH: What Are You Working On?,40649)
(HH Design,39851)
(HH Hacker Problems,14539)
(Hackathon Hackers EU,14432)
(HH Data Hackers,13657)
(HH Webdev,9903)
(HH iOS,5349)
(HH Throw a Hackathon,5047)
(HH: Snackathon Snackers,4122)
(HH: VR,2902)
(HH Free Stuff,2772)
(HH Growthhacking,2409)
(HH CTF,1481)
(HH Canada Eh?,1290)
(HH Skillshare,1180)
(HH Blog Posts,1066)
(HH Connect,1042)
(HH FIRST + VEX,976)
(HH: Book Club,719)
(HH EdTech,695)
(HH South,542)
(HH Python,479)
(HH Texas,419)
(HH Social Good,392)
(HH Systems Programming,374)
(HH Africa,358)
(HH Hardware Hackers,301)
(HH Futurism,298)
(HH Internet of Things,197)
(HH: Code Reviews,191)
(Hackathon Hackers Asia,186)
(HH Constructive Debates,128)
(HH Product Launch,86)
(HH: Share Your Projects,67)
(HH λ,62)
(Hackathon Hackers South East Asia (SEA),58)


## Types

(like,516458)
(comment,155369)
(status,11430)
(link,6118)
(photo,859)
(video,688)
(event,164)
(note,2)
(offer,1)


## Like ranking

(Hackathon Hackers,1000,status,#hackerinchief)
(Hackathon Hackers,1000,status,Mac is now supporting Windows!)
(Hackathon Hackers,903,photo,git commit -m "Fixed interface issues."

source: twitter)
(Hackathon Hackers,757,photo,Zuck actually checks his facebook.)
(Hackathon Hackers,645,status,)
(Hackathon Hackers,626,photo,Yo! This guy's license plate says "NODE JS" #paloalto)
(Hackathon Hackers,606,status,ohhhhhhhhhh babyyyyyy ;))
(Hackathon Hackers,586,link,Thinking of dropping out? I wrote a bit on what you'll go through.)
(Hackathon Hackers,540,status,Who's down to bring a hackathon to Ahmed's community? We must encourage that kid to keep building and educate those around him. #hellyeah?)
(Hackathon Hackers,517,status,Seems legit!)



## Likes and comments average
We only consider status, links, photo, video, comment.

(link,11.275253350768224,5.315299117358614)
(photo,28.21885913853318,8.679860302677533)
(video,9.795058139534884,4.125)
(status,10.356167979002624,9.236482939632547)
(comment,1.9140304693986574,0.0)


# Instruction
## Upload perl script to Webserver on the Cluster

gcloud compute copy-files facebook_Graph_Data_Table.pl webserver:/tmp

## move the perl script to /var/
sudo mv /tmp/facebook_Graph_Data_Table.pl /var/www/cgi-bin/yiqin/

## change mod.
sudo chmod 777 facebook_Graph_Data_Table.pl


## Upload jar to Hadoop on the Cluster
gcloud compute copy-files uber-yiqin-0.0.1-SNAPSHOT.jar hadoop-m:/mnt/scratch/yiqin

## Run jar on Hadoop on the Cluster
hadoop jar uber-yiqin-0.0.1-SNAPSHOT.jar edu.uchicago.yiqin.SerializeFacebookGraphNode  /mnt/scratch/yiqin/input
Don't forget the class, which contains the main.

## Change Pig file to Cluster mode.

## Open url
http://104.197.20.219/cgi-bin/yiqin/facebook_Graph_Data_Table.pl

## kafka
## create a topic 
kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic yiqin-facebook

## Read the data
kafka-console-consumer.sh --zookeeper localhost:2181 --topic yiqin-facebook --from-beginning



