use strict;
use warnings;
use Test::More tests => 8;

do {
    package Mock;
    use Test::MockOO::Declare;
    extends 'Moose::Meta::Attribute';

    has wave_function => (
        is        => 'ro',
        reader    => 'observe',
        lazy      => 1,
        default   => sub { rand(1) < 0.5 ? 'particle' : 'wave' },
        predicate => 'has_collapsed',
    );

    always has_trigger => 1;
};

my $object = Test::MockOO->create('Mock');
isa_ok($object, 'Mock');
isa_ok($object, 'Moose::Meta::Attribute');
can_ok($object, qw(associated_class has_trigger observe has_collapsed));

ok($object->has_trigger, "'always' overrode Attribute's has_trigger");
ok(!$object->Moose::Meta::Attribute::has_trigger, "original has_trigger untouched");

ok(!$object->has_collapsed, 'still exhibiting duality');

my $nature = $object->observe;

ok($object->has_collapsed, 'true nature revealed');

my $consistent = 0;
for (1 .. 100) {
    $consistent++ if $object->observe eq $nature;
}

is($consistent, 100, "object's nature was consistent");

