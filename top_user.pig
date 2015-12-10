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


-- Define a macro to get the top 100 for each subgroup.
DEFINE get_top_100_subgroup(input_data, key) RETURNS result {
  subgroup = FILTER $input_data BY group_name == $key;
  group_by_user = group subgroup by from_id;

  count_by_user_in_group = foreach group_by_user generate group as from_id, subgroup.from_name as from_name, $key as group_name, COUNT(subgroup) as count;

  flatten_count = foreach count_by_user_in_group generate from_id, FLATTEN(from_name), group_name, count;
  distinct_count = DISTINCT flatten_count;

  ordered_distinct_count = ORDER distinct_count by count DESC;
  $result = limit ordered_distinct_count 50;
}


-- Load raw data
load_data = load '/mnt/scratch/yiqin' using SequenceFileLoader as (key:int, val:bytearray);
raw_data = foreach load_data generate flatten(ThriftBytesToTupleDef(val));

-- subgroups
group_1 = get_top_100_subgroup(raw_data, '\'Hackathon Hackers\'');
group_2 = get_top_100_subgroup(raw_data, '\'HH: What Are You Working On?\'');
group_3 = get_top_100_subgroup(raw_data, '\'HH Design\'');
group_4 = get_top_100_subgroup(raw_data, '\'HH Hacker Problems\'');
group_5 = get_top_100_subgroup(raw_data, '\'Hackathon Hackers EU\'');
group_6 = get_top_100_subgroup(raw_data, '\'HH Data Hackers\'');
group_7 = get_top_100_subgroup(raw_data, '\'HH Webdev\'');
group_8 = get_top_100_subgroup(raw_data, '\'HH iOS\'');
group_9 = get_top_100_subgroup(raw_data, '\'HH Throw a Hackathon\'');
group_10 = get_top_100_subgroup(raw_data, '\'HH: Snackathon Snackers\'');
group_11 = get_top_100_subgroup(raw_data, '\'HH: VR\'');
group_12 = get_top_100_subgroup(raw_data, '\'HH Free Stuff\'');
group_13 = get_top_100_subgroup(raw_data, '\'HH Growthhacking\'');
group_14 = get_top_100_subgroup(raw_data, '\'HH CTF\'');
group_15 = get_top_100_subgroup(raw_data, '\'HH Canada Eh?\'');
group_16 = get_top_100_subgroup(raw_data, '\'HH Skillshare\'');
group_17 = get_top_100_subgroup(raw_data, '\'HH Blog Posts\'');
group_18 = get_top_100_subgroup(raw_data, '\'HH Connect\'');
group_19 = get_top_100_subgroup(raw_data, '\'HH FIRST + VEX\'');
group_20 = get_top_100_subgroup(raw_data, '\'HH: Book Club\'');
group_21 = get_top_100_subgroup(raw_data, '\'HH EdTech\'');
group_22 = get_top_100_subgroup(raw_data, '\'HH South\'');
group_23 = get_top_100_subgroup(raw_data, '\'HH Python\'');
group_24 = get_top_100_subgroup(raw_data, '\'HH Texas\'');
group_25 = get_top_100_subgroup(raw_data, '\'HH Social Good\'');

union_2 = UNION group_1, group_2;
union_3 = UNION union_2, group_3;
union_4 = UNION union_3, group_4;
union_5 = UNION union_4, group_5;
union_6 = UNION union_5, group_6;
union_7 = UNION union_6, group_7;
union_8 = UNION union_7, group_8;
union_9 = UNION union_8, group_9;
union_10 = UNION union_9, group_10;
union_11 = UNION union_10, group_11;
union_12 = UNION union_11, group_12;
union_13 = UNION union_12, group_13;
union_14 = UNION union_13, group_14;
union_15 = UNION union_14, group_15;
union_16 = UNION union_15, group_16;
union_17 = UNION union_16, group_17;
union_18 = UNION union_17, group_18;
union_19 = UNION union_18, group_19;
union_20 = UNION union_19, group_20;
union_21 = UNION union_20, group_21;
union_22 = UNION union_21, group_22;
union_23 = UNION union_22, group_23;
union_24 = UNION union_23, group_24;
union_25 = UNION union_24, group_25;

-- dump union_3;



-- Store to HBase
hbase_data = foreach union_25 generate CONCAT($2, $0), $0, $1, $2, $3;

STORE hbase_data INTO 'hbase://yiqin_facebook_graph_data_by_top_user'
 USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('user:from_id, user:from_name, user:group_name, user:count');






