package Test::MockOO;
use strict;
use warnings;
use Scalar::Util 'blessed';

use Test::MockOO::Class;

sub create {
    my $self    = shift;
    my $genitor = shift;

    my $class;

    if (blessed($genitor)) {
        # ->new(Mock->meta)
        if ($genitor->isa('Test::MockOO::Class')) {
            $class = $genitor;
        }
        # ->new(Foreign->new)
        else {
            $class = Test::MockOO::Class->create_anon_class(
                superclasses => [Scalar::Util::blessed($genitor)],
            );
        }
    }
    elsif ($genitor) {
        my $metaclass = Class::MOP::class_of($genitor);
        # ->new('Mock')
        if ($metaclass && $metaclass->isa('Test::MockOO::Class')) {
            $class = Class::MOP::class_of($genitor);
        }
        # ->new('Foreign')
        else {
            $class = Test::MockOO::Class->create_anon_class(
                superclasses => [$genitor],
            );
        }
    }
    else {
        $class = Test::MockOO::Class->create_anon_class;
    }

    my $instance = $class->new_object;

    return $instance if !wantarray;
    return ($class, $instance);
}

1;

