use strict;
use warnings;
use Test::More tests => 11;

do {
    package Mock;
    use Test::MockOO::Declare;

    true 'works';
    false "does_not";

    always name => 'Leto';

    my $i = 0;
    mock counter => sub { ++$i };

    series troll => qw(Tom Bert Bill);
};

my $object = Test::MockOO->create('Mock');
isa_ok($object, 'Mock');
can_ok($object, qw(works does_not name counter troll));

ok($object->works, 'true works');
ok(!$object->does_not, 'false works');
is($object->name, 'Leto', 'always');

is($object->counter, 1);
is($object->counter, 2);

is($object->troll, 'Tom');
is($object->troll, 'Bert');
is($object->troll, 'Bill');
is($object->troll, undef);
