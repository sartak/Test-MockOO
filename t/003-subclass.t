use strict;
use warnings;
use Test::More tests => 2;
use Test::MockOO;
use Scalar::Util 'blessed';

my ($class, $object) = Test::MockOO->create('Moose::Meta::Attribute');
isa_ok($object, 'Moose::Meta::Attribute');
isnt(blessed($object), 'Moose::Meta::Attribute', 'anonymous subclass');

ok(!$object->has_trigger, 'no trigger yet');
$class->set_true('has_trigger');
ok($object->has_trigger, 'trigger faked out');

