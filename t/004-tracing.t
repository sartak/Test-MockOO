use strict;
use warnings;
use Test::More tests => 15;
use Test::MockOO;

my ($class, $object) = Test::MockOO->create;
my $calls = $class->calls_for($object);

$class->set_true('method');

is($calls->calls, 0, 'no calls yet');
$object->method;
is($calls->calls, 1, 'made a call');
$calls->called_ok('method');

my $call = $calls->called('method');
isa_ok($call, 'Test::MockOO::Call');
is($call->name, 'method', 'method name');
is($call->invocant, $object, 'invocant');
is_deeply($call->arguments, [$object], 'all arguments');

my $no_call = $calls->called('nonexistent');
ok(!$no_call, 'no call was made');

$calls->clear;
is($calls->calls, 0, 'no more calls');

$object->method('a', 'z');

is($calls->calls, 1, 'made a call');
$calls->called_ok('method');

$call = $calls->called('method');
isa_ok($call, 'Test::MockOO::Call');
is($call->name, 'method', 'method name');
is($call->invocant, $object, 'invocant');
is_deeply($call->arguments, [$object, 'a', 'z'], 'all arguments');

