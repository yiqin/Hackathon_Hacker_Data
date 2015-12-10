#!/usr/bin/perl -w
# Program: cass_sample.pl
# Note: includes bug fixes for Net::Async::CassandraCQL 0.11 version

use strict;
use warnings;
use 5.10.0;
use FindBin;

use Scalar::Util qw(
        blessed
    );
use Try::Tiny;

use Kafka::Connection;
use Kafka::Producer;

use Data::Dumper;
use CGI qw/:standard/, 'Vars';

my $from_name = param('from_name');
if(!$from_name) {
    exit;
}

my $type = param('type');
my $facebook_message = param('message');

my ( $connection, $producer );
try {
    #-- Connection
    # $connection = Kafka::Connection->new( host => 'sandbox.hortonworks.com', port => 6667 );
    $connection = Kafka::Connection->new( host => 'hadoop-m.c.mpcs53013-2015.internal', port => 6667 );

    #-- Producer
    $producer = Kafka::Producer->new( Connection => $connection );
    # Only put in the station_id and weather elements because those are the only ones we care about
    my $message = "<new_facebook><from_name>".$from_name."</from_name>";
    if($type) { $message .= "<type>".$type."</type>"; }
    if($facebook_message) { $message .= "<message>".$facebook_message."</message>"; }
    $message .= "</new_facebook>";

    # Sending a single message
    my $response = $producer->send(
	'yiqin-facebook',          # topic
	0,                                 # partition
	$message                           # message
        );
} catch {
    if ( blessed( $_ ) && $_->isa( 'Kafka::Exception' ) ) {
	warn 'Error: (', $_->code, ') ',  $_->message, "\n";
	exit;
    } else {
	die $_;
    }
};

# Closes the producer and cleans up
undef $producer;
undef $connection;

print header, start_html(-title=>'Submit new facebook data',-head=>Link({-rel=>'stylesheet',-href=>'/table.css',-type=>'text/css'}));
print table({-class=>'CSS_Table_Example', -style=>'width:80%;'},
           caption('Facebook graph node submitted'),
            Tr([td(["Username","Type","Message"]),
            td([$from_name, $type, $facebook_message])]));

#print $protocol->getTransport->getBuffer;
print end_html;

