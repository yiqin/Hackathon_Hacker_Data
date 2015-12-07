# Hackathon_Hacker_Data

# Project Description

We get the data from Facebook using Facebook Graph API. The dataset are from about Hackathon Hackers (HH), which has become the biggest Facebook group for hackathon attendees. Currently, it has over 18k members. It's a place to discuss hackathons, tech news, college, high school, and dank memes. It had 53 different public subgroups. 

Facebook limits developers to any public graph data at Facebook due to the privary. This dataset in csv file is 245.5 MB. The time range is from 7/1/2014 - 8/20/2015, which is more than one year. This is the larget dataset I could get from Facebook Graph API. It has more than 1,300,000 items. It includes information about members' likes, comments and posts. 

# Current Progress
The batch layer is ready. ```csv``` dataset are uploaded ```/mnt/scratch/yiqin/input``` in the cluster. facebookGraphNode.thrift is created to process the data. ```uber-yiqin-0.0.1-SNAPSHOT.jar``` is also in the cluster. ```create_Facebook_Graph_Data_Table.pig``` is to create the table and show the table. You can see the data are stored.

Facebook graph data are so difficult to deal with, but contain interesting information. I'm going to finish the project in the next 4 days.
