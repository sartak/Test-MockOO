package Test::MockOO::Class;
use Moose;

extends 'Moose::Meta::Class';

with (
    'Test::MockOO::Mocks',
    'Test::MockOO::CallTracing',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

