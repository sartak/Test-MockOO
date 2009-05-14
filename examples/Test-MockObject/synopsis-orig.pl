use Test::MockObject;
my $mock = Test::MockObject->new();
$mock->set_true( 'somemethod' );
ok( $mock->somemethod() );

$mock->set_true( 'veritas')
       ->set_false( 'ficta' )
     ->set_series( 'amicae', 'Sunny', 'Kylie', 'Bella' );
