#!/usr/bin/perl -w
# Creates an html table of flight delays by weather for the given route

# Needed includes
use strict;
use warnings;
use 5.10.0;
use HBase::JSONRest;
use CGI qw/:standard/;


# Define a connection template to access the HBase REST server
# If you are on out cluster, hadoop-m will resolve to our Hadoop master
# node, which is running the HBase REST server
my $hbase = HBase::JSONRest->new(host => "hadoop-m:2056");

# This function takes a row and gives you the value of the given column
# E.g., cellValue($row, 'delay:rain_delay') gives the value of the
# rain_delay column in the delay family.
# It uses somewhat tricky perl, so you can treat it as a black box
sub cellValue {
    my $row = $_[0];
    my $field_name = $_[1];
    my $row_cells = ${$row}{'columns'};
    foreach my $cell (@$row_cells) {
	if ($$cell{'name'} eq $field_name) {
	    return $$cell{'value'};
	}
    }
    return 'missing';
}

# Query hbase for the route. For example, if the departure airport is ORD
# and the arrival airport is DEN, the "where" clause of the query will
# require the key to equal ORDDEN
my $records = $hbase->get({
  table => 'yiqin_facebook_graph_data_by_count_activities',
});

my @sorted_records = sort { cellValue($b, 'count_activities:count') <=> cellValue($a, 'count_activities:count') } @$records;

my $total = 0;

foreach (@sorted_records) {
   my $count = cellValue($_, 'count_activities:count');
   $total = $total + $count;
}

# There will only be one record for this route, which will be the
# "zeroth" row returned


# Print an HTML page with the table. Perl CGI has commands for all the
# common HTML tags
print header, start_html(-title=>'General Information',-head=>Link({-rel=>'stylesheet',-href=>'/spertus/flights/table.css',-type=>'text/css'}));

print div({-style=>'margin-left:275px;margin-right:auto;display:inline-block;box-shadow: 10px 10px 5px #888888;border:1px solid #000000;-moz-border-radius-bottomleft:9px;-webkit-border-bottom-left-radius:9px;border-bottom-left-radius:9px;-moz-border-radius-bottomright:9px;-webkit-border-bottom-right-radius:9px;border-bottom-right-radius:9px;-moz-border-radius-topright:9px;-webkit-border-top-right-radius:9px;border-top-right-radius:9px;-moz-border-radius-topleft:9px;-webkit-border-top-left-radius:9px;border-top-left-radius:9px;background:white'}, '&nbsp;There are more than 30 subgroups in Hackathon Hacker Community. Hackathon Hackers is for general information. Users can post anything in related subgroups. &nbsp;');
print     p({-style=>"bottom-margin:10px"});



print '<table border="1" align="center">';

# table headings are SQL column names

print "<tr><th>'name'</th><th>'activities count'</th><th>' % '</th></tr>";


foreach (@sorted_records) {

# Get the value of all the columns we need and store them in named variables
# Perl's ability to assign a list of values all at once is very convenient here
my($group_name, $count)
 =  (cellValue($_, 'count_activities:group_name'), cellValue($_, 'count_activities:count'));


# print table({-class=>'CSS_Table_Example', -style=>'width:60%;margin:auto;'},
# 	    Tr([td(['group name', 'counts']),
#                 td([$group_name, $count])])),
#     p({-style=>"bottom-margin:10px"})
#     ;

# print p({-style=>'margin:auto;margin-left:275px;display:inline-block;padding:10px;'}, $group_name);
# print br();

my $percentage = sprintf("%.3f",(int($count)/int($total)*100));

print "<tr><td>$group_name</td><td>$count</td><td>$percentage</td></tr>\n";


}

print "</table>\n";


print end_html;
