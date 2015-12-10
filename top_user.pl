#!/usr/bin/perl -w
# Creates an html table of flight delays by weather for the given route

# Needed includes
use strict;
use warnings;
use 5.10.0;
use HBase::JSONRest;
use CGI qw/:standard/;

my $selected_group_name = param('group_name');

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

# Print an HTML page with the table. Perl CGI has commands for all the
# common HTML tags
print header, start_html(-title=>'General Information',-head=>Link({-rel=>'stylesheet',-href=>'/yiqin/table.css',-type=>'text/css'}));

print div({-style=>'margin-left:275px;margin-right:auto;display:inline-block;box-shadow: 10px 10px 5px #888888;border:1px solid #000000;-moz-border-radius-bottomleft:9px;-webkit-border-bottom-left-radius:9px;border-bottom-left-radius:9px;-moz-border-radius-bottomright:9px;-webkit-border-bottom-right-radius:9px;border-bottom-right-radius:9px;-moz-border-radius-topright:9px;-webkit-border-top-right-radius:9px;border-top-right-radius:9px;-moz-border-radius-topleft:9px;-webkit-border-top-left-radius:9px;border-top-left-radius:9px;background:white'}, '&nbsp;In this ' . $selected_group_name . ' subgroup, top 20 active users are: &nbsp;');
print     p({-style=>"bottom-margin:10px"});


# Query hbase for the route. For example, if the departure airport is ORD
# and the arrival airport is DEN, the "where" clause of the query will
# require the key to equal ORDDEN
my $records = $hbase->get({
  table => 'yiqin_facebook_graph_data_by_top_user',
  where => {
   key_begins_with => $selected_group_name
 },
});

my @filted_records = grep { cellValue($_, 'user:group_name') eq $selected_group_name } @$records;

my @sorted_records = sort { cellValue($b, 'user:count') <=> cellValue($a, 'user:count') } @filted_records;

my $row_number = 1;

print '<table border="1" align="center">';

# table headings are SQL column names

print "<tr><th>ranking</th><th>'user name'</th><th>'activities count'</th></tr>";


foreach (@sorted_records) {

  # Get the value of all the columns we need and store them in named variables
  # Perl's ability to assign a list of values all at once is very convenient here
  my($from_name, $count)
 =  (cellValue($_, 'user:from_name'), cellValue($_, 'user:count'));

  print "<tr><td>$row_number</td><td>$from_name</td><td>$count</td></tr>\n";

if ($row_number eq 20) {
  last;
}
$row_number = $row_number + 1;


}

print "</table>\n";


print end_html;
