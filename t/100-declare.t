use strict;
use warnings;
use Test::More tests => 4;

do {
    package Mock;
    use Test::MockOO::Declare;

    true 'works';
    false "does_not";
};

my $object = Test::MockOO->create('Mock');
isa_ok($object, 'Mock');
can_ok($object, qw(works does_not));
ok($object->works, 'true works');
ok(!$object->does_not, 'false works');

