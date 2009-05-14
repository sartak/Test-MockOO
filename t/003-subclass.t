use strict;
use warnings;
use Test::More tests => 7;
use Test::MockOO;
use Scalar::Util 'blessed';

my ($no_superclass) = Test::MockOO->create;
is_deeply([$no_superclass->superclasses], [], 'no superclass by default');
ok(!$no_superclass->name->can('new'), 'no constructor by default');

my ($class, $object) = Test::MockOO->create('Moose::Meta::Attribute');
isa_ok($object, 'Moose::Meta::Attribute');
isnt(blessed($object), 'Moose::Meta::Attribute', 'anonymous subclass');

ok(!$object->has_trigger, 'no trigger yet');
$class->set_true('has_trigger');
ok($object->has_trigger, 'trigger faked out');
ok(!$object->Moose::Meta::Attribute::has_trigger, 'original method is fine');

