package Test::MockOO::Class;
use Moose;

extends 'Moose::Meta::Class';



__PACKAGE__->meta->make_immutable;
no Moose;

1;

