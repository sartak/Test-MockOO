use Test::MockOO;
my ($class, $mock) = Test::MockOO->create();
$class->set_true( 'somemethod' );
ok( $mock->somemethod() );

$class->set_true( 'veritas' )
        ->set_false( 'ficta' )
      ->set_series( 'amicae', 'Sunny', 'Kylie', 'Bella' );

