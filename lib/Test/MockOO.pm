package Test::MockOO;
use strict;
use warnings;
use Test::MockOO;

sub create {
    my $self    = shift;
    my $genitor = shift;

    my $class;

    if (blessed $genitor) {
        # ->new(Mock->meta)
        if ($genitor->isa('Test::MockObject::Class')) {
            $class = $genitor;
        }
        # ->new(Foreign->new)
        else {
            $class = Test::MockObject::Class->create_anon_class(
                superclasses => [Scalar::Util::blessed($genitor)],
            );
        }
    }
    elsif ($genitor) {
        my $metaclass = Class::MOP::class_of($genitor);
        # ->new('Mock')
        if ($metaclass && $metaclass->isa('Test::MockObject::Class')) {
            $class = Class::MOP::class_of($genitor);
        }
        # ->new('Foreign')
        else {
            $class = Test::MockObject::Class->create_anon_class(
                superclasses => [$genitor],
            );
        }
    }
    else {
        $class = Test::MockObject::Class->create_anon_class;
    }

    return $instance if !wantarray;
    return ($class, $instance);
}

1;

