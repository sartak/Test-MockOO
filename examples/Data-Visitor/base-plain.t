#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 32;
use Test::MockObject;

my $m;
use ok $m = "Data::Visitor";

can_ok($m, "new");
isa_ok(my $o = $m->new, $m);

can_ok( $o, "visit" );

my @things = ( "foo", 1, undef, 0, {}, [], do { my $x = "blah"; \$x }, bless({}, "Some::Class") );

$o->visit($_) for @things; # no explosions in void context

is_deeply( $o->visit( $_ ), $_, "visit returns value unlatered" ) for @things;

can_ok( $o, "visit_value" );
can_ok( $o, "visit_object" );
can_ok( $o, "visit_hash" );
can_ok( $o, "visit_array" );


my ($class, $mock) = Test::MockOO->new( $o );

# cause logging
$class->set_always( $_ => "magic" ) for qw/visit_value visit_object/;
$class->mock( visit_hash_key => sub { $_[1] } );
$class->mock( visit_hash => sub { shift->Data::Visitor::visit_hash( @_ )  } );
$class->mock( visit_array => sub { shift->Data::Visitor::visit_array( @_ )  } );

my $calls = $class->calls_of( $mock );
$calls->clear;
$mock->visit( "foo" );
$calls->called_ok( "visit_value" );

$calls->clear;
$mock->visit( 1 );
$calls->called_ok( "visit_value" );

$calls->clear;
$mock->visit( undef );
$calls->called_ok( "visit_value" );

$calls->clear;
$mock->visit( [ ] );
$calls->called_ok( "visit_array" );
ok( !$calls->called( "visit_value" ), "visit_value not called" );

$calls->clear;
$mock->visit( [ "foo" ] );
$calls->called_ok( "visit_array" );
$calls->called_ok( "visit_value" );

$calls->clear;
$mock->visit( "foo" );
$calls->called_ok( "visit_value" );

$calls->clear;
$mock->visit( {} );
$calls->called_ok( "visit_hash" );
ok( !$calls->called( "visit_value" ), "visit_value not called" );

$calls->clear;
$mock->visit( { foo => "bar" } );
$calls->called_ok( "visit_hash" );
$calls->called_ok( "visit_value" );

$calls->clear;
$mock->visit( bless {}, "Foo" );
$calls->called_ok( "visit_object" );

is_deeply( $mock->visit( undef ), "magic", "fmap behavior on value" );
is_deeply( $mock->visit( { foo => "bar" } ), { foo => "magic" }, "fmap behavior on hash" );
is_deeply( $mock->visit( [qw/la di da/]), [qw/magic magic magic/], "fmap behavior on array" );

