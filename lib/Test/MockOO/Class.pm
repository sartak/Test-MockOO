package Test::MockOO::Class;
use Moose 0.80; # Moose < 0.80 has bugs with anonymous classes

extends 'Moose::Meta::Class';

with (
    'Test::MockOO::Mocks',
    'Test::MockOO::CallTracing',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

