use strict;
use warnings;
use Test::More tests => 9;
use Test::MockOO;
use Scalar::Util 'blessed';

my ($class, $object) = Test::MockOO->create;
isa_ok($class, 'Test::MockOO::Class');
ok($class->is_anon_class, 'class is anonymous');

my ($class2, $object2) = Test::MockOO->create($class);
is($class, $class2, 'same class');
is(blessed($object), blessed($object2), 'objects are the same class');

my $object3 = Test::MockOO->create($class);
is(blessed($object), blessed($object3), 'objects are the same class');

my $object4 = Test::MockOO->create($object);
isnt(blessed($object), blessed($object4), 'new class');
isa_ok($object4, blessed($object));

my $object5 = Test::MockOO->create;
isnt(blessed($object), blessed($object5), 'new class');

my $object6 = Test::MockOO->create;
isnt(blessed($object5), blessed($object6), 'new class');

