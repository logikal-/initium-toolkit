package pathAlgorithm;

@ISA = qw(Exporter);
@EXPORT_OK = qw/shortest_path() free_path_event() debug()/;

use strict;

sub new
{
        my ($class , %vals)  = @_;
	my $self;
        bless $self =
        {	
			graph   => $vals{-graph},
			origin  => $vals{-origin},
			destiny => $vals{-destiny},
			sub	=> $vals{-sub},
	} , $class;
	return $self;
}

sub push_paths
{
        my ($self,@nodes) = @_;
	push @{$self->{paths}} , \@nodes;
}

sub get_path_cost
{
        my ($self,@nodes) = @_;
        return unless @nodes;
	my $ant_node = shift @nodes;
	my $cur_node = shift @nodes;
	return 0 if (!$cur_node) || 
		    ($ant_node eq $cur_node) || 
		    (!$self->{graph}{$ant_node}{$cur_node});
	return  $self->{graph}{$ant_node}{$cur_node} + $self->get_path_cost($cur_node,@nodes);
}

sub shortest_path
{
	my ($self,$father) = @_;
	$father = 'zero' if $father eq '0';
	my $tmp = $self->{sub} if $self->{sub};
	$self->{sub} = \&push_paths;
	$self->free_path_event($father);
	$self->{sub} = $tmp;
	my ($minor_cost,$pass,%paths_minor_cost) = (0,0,());
	for my $path (@{$self->{paths}})
        {
		my $cost = $self->get_path_cost(@{$path});
		if ( ($cost <= $minor_cost) || ($minor_cost == 0) )
                {
			push @{$paths_minor_cost{$cost}} , $path; 
			$minor_cost = $cost;
		}
		$pass=1;
	}
	return @{$paths_minor_cost{$minor_cost}} if $pass;
	return [0] unless $pass;
}

sub free_path_event
{
	my ($self , $father ) = @_;
	$father = 'zero' if $father eq '0';
	$father = $self->{origin} unless $father;
	$self->{fathers}{$father}=1;
	push @{$self->{path}} , $father;
	foreach my $node (keys %{$self->{graph}{$father}})
        {
		my $pass=0;
		$pass=1 if $node eq $self->{origin} || $node eq $self->{destiny};
		if ($node eq $self->{destiny})
                {
			push @{$self->{path}} , $self->{destiny};	
			$self->{sub}->($self,@{$self->{path}});
			pop @{$self->{path}};
		}
		$self->free_path_event($node) if (!$self->{fathers}{$node}) && (!$pass);
	}
	$self->{fathers}{$father}=0;
	pop @{$self->{path}};
}

sub debug
{
	my ($self , $father ,$level) = @_;
	$father = 'zero' if $father eq '0';
	$level = 1 unless $level;
	$father = $self->{origin} unless $father;
	$self->debug_msg($level,"Node:[$father] Save node into path hash\n");
	$self->{fathers}{$father}=1;
	push @{$self->{path}} , $father;
	$self->debug_msg($level,"Node:[$father] Finding path into graph hash\n");
	foreach my $node (keys %{$self->{graph}{$father}})
        {
		my $pass=0;
		$self->debug_msg($level,"_Node:[$node] Checking if is not origin or detiny Node\n");
		if ($node eq $self->{origin} || $node eq $self->{destiny})       
                {
			$self->debug_msg($level,"__Node:[$node] Is equal\n");
			$pass=1 
		} 
                else
                {
			$self->debug_msg($level,"__Node:[$node] Is not equal\n");
		}
		$self->debug_msg($level,"_Node:[$node] Checking is Node equal destiny Node\n");
		if ($node eq $self->{destiny})
                {
			$self->debug_msg($level,"__Node:[$node] Is equal\n");
			$self->debug_msg($level,"__Got Current Path :" . join("->",@{$self->{path}}) . "\n") ;
			push @{$self->{path}} , $self->{destiny};	
			#$self->{sub}->($self, @{$self->{path}});
			pop @{$self->{path}};
		}
                else
                {
			$self->debug_msg($level,"__Node:[$node] Is not equal\n");
		}
		$self->debug_msg($level,"_Node:[$node] Calling method self recurcive\n");
		$self->debug($node,$level + 1) if (!$self->{fathers}{$node}) && (!$pass);
	}
	$level--;
	$self->{fathers}{$father}=0;
	my $tmp = pop @{$self->{path}};
	$self->debug_msg($level,"Node[$father] Exiting Node\n");
}

sub debug_msg
{
	my ($self, $level , $msg ) = @_;
	print "|_" for 1 .. $level;
	print $msg;
	sleep 1;
}


1;
