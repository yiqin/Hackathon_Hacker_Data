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

-- General Information

-- types count
group_by_types = group raw_data BY FacebookGraphNode::type; 
types_count = foreach group_by_types generate group as id, group as type, COUNT (raw_data) as occurrences;
types_count_ordered = order types_count by occurrences DESC;

dump types_count_ordered;


-- Likes ranking
like_data = foreach raw_data generate group_name as group_name, like_count as like_count, type as type, message as message;
like_ordered = order like_data by like_count DESC;
like_ordered_10 = limit like_ordered 10;

dump like_ordered_10;


-- Comments ranking
comment_data = foreach raw_data generate group_name as group_name, comment_count as comment_count, type as type, message as message;
comment_ordered = order comment_data by comment_count DESC;
comment_ordered_10 = limit comment_ordered 10;

dump comment_ordered_10


-- likes and comments average
filted_raw_data_1 = FILTER raw_data BY type == 'status' or type == 'link' or type == 'photo' or type == 'video' or type == 'comment';
group_by_types_filted_raw_data = group filted_raw_data_1 BY type;

A = foreach group_by_types_filted_raw_data generate group as id, group as type, AVG($1.like_count) as like_avg, AVG($1.comment_count) as comment_avg;

B = order A by type ASC;

dump A;


