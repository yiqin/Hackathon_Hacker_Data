namespace java edu.uchicago.mpcs53013.facebookGraphNode

struct FacebookGraphNode {
	1: required string id;
	2: required i32 level;
	3: required string from_id;
	4: required string from_name;
	5: required string group_id;
	6: required string group_name;
	7: required string message;
	8: required string created_time;
	9: required string updated_time;
	10: required string type;
	11: required string picture;
	12: required string link;
	13: required string source;
	14: required string name;
	15: required string caption;
	16: required string description;
	17: required i32 like_count;
	18: required i32 comment_count;
	19: required string parent_id;
	20: required string parent_type;
	21: required string comment_index;
}