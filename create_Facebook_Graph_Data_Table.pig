-- 
register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar

-- glcoud setting
register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
register uber-yiqin-0.0.1-SNAPSHOT.jar;

-- VM setting
-- register /usr/hdp/2.2.4.2-2/pig/lib/piggybank.jar;
-- register /usr/hdp/2.2.4.2-2/hive/lib/libthrift-0.9.0.jar;
-- register /home/mpcs53013/Hackathon_Hacker_Data/yiqin/target/yiqin-0.0.1-SNAPSHOT.jar


DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.facebookGraphNode.FacebookGraphNode');

load_data = load '/mnt/scratch/yiqin' using SequenceFileLoader as (key:int, val:bytearray);
raw_data = foreach load_data generate flatten(ThriftBytesToTupleDef(val));

-- Count activities in subgroups
group_by_subgroup = group raw_data BY FacebookGraphNode::group_name;
activities_count_subgroup = foreach group_by_subgroup generate group as group_name, COUNT(raw_data) as occurrences;
activities_count_subgroup_ordered = order activities_count_subgroup by occurrences DESC;

A = foreach activities_count_subgroup_ordered generate $0 as id, $0, $1;

dump A;

-- Store to HBase
STORE activities_count_subgroup_ordered INTO 'hbase://yiqin_facebook_graph_data_by_count_activities'
 USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('activities:group_name', 'activities:occurrences');






