register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar
register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
register uber-yiqin-0.0.1-SNAPSHOT.jar;

DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.facebookGraphNode.FacebookGraphNode');

A = load '/mnt/scratch/yiqin' using SequenceFileLoader as (key:int, val:bytearray);
B = foreach A generate FLATTEN(ThriftBytesToTupleDef(val));
C = limit B 10;
dump C;


