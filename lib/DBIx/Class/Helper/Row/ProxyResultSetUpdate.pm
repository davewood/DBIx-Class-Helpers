package DBIx::Class::Helper::Row::ProxyResultSetUpdate;

use base 'DBIx::Class::Helper::Row::SelfResultSet';

# copied directly from DBIx::Class::Row with single slight modification
sub update {
  my ($self, $upd) = @_;

  $self->set_inflated_columns($upd) if $upd;

  my %to_update = $self->get_dirty_columns
    or return $self;

  $self->throw_exception( "Not in database" ) unless $self->in_storage;

  my $rows = $self->self_rs->update(\%to_update);
  if ($rows == 0) {
    $self->throw_exception( "Can't update ${self}: row not found" );
  } elsif ($rows > 1) {
    $self->throw_exception("Can't update ${self}: updated more than one row");
  }
  $self->{_dirty_columns} = {};
  $self->{related_resultsets} = {};
  delete $self->{_column_data_in_storage};
  return $self;
}

1;
