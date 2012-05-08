package Lexicon::TestStorage;
use Moose;

use Lexicon::Edit;

has _turns => (
  isa => 'ArrayRef[Lexicon::Edit]',
  traits   => [ 'Array' ],
  init_arg => undef,
  default  => sub {  []  },
  handles  => {
    last_turn => [ get => -1 ],
    _save_turn => 'push',
  },
);

has pages => (
  isa    => 'HashRef',
  traits => [ 'Hash' ],
  init_arg => undef,
  default  => sub {  {}  },
  handles  => {
    page_names  => 'keys',
    page_content => 'get',
    set_page_content => 'set',
  },
);

sub save_edit {
  my ($self, $edit) = @_;
  $self->_save_turn($edit) unless $edit->is_typo_fix;

  my %content = $edit->page_contents;
  $self->set_page_content($_, $content{$_}) for keys %content;
}

with 'Lexicon::Storage';

1;
