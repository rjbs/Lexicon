package Lexicon::X;
use Moose;
with 'Throwable::X';

use overload '""' => 'message', fallback => 1;

1;
