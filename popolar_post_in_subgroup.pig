-- 
register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar

-- glcoud setting
-- register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
-- register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
-- register uber-yiqin-0.0.1-SNAPSHOT.jar;

-- VM setting
register /usr/hdp/2.2.4.2-2/pig/lib/piggybank.jar;
register /usr/hdp/2.2.4.2-2/hive/lib/libthrift-0.9.0.jar;
register /home/mpcs53013/Hackathon_Hacker_Data/yiqin/target/yiqin-0.0.1-SNAPSHOT.jar


DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.facebookGraphNode.FacebookGraphNode');

load_data = load '/mnt/scratch/yiqin' using SequenceFileLoader as (key:int, val:bytearray);
raw_data = foreach load_data generate flatten(ThriftBytesToTupleDef(val));


-- distinct subgroups
group_names = foreach raw_data GENERATE FacebookGraphNode::group_name;
distinct_group_name = DISTINCT group_names;

dump distinct_group_name;

-- 










