#############################################################################
#  OpenKore - Network subsystem												#
#  This module contains functions for sending messages to the server.		#
#																			#
#  This software is open source, licensed under the GNU General Public		#
#  License, version 2.														#
#  Basically, this means that you're allowed to modify and distribute		#
#  this software. However, if you distribute modified versions, you MUST	#
#  also distribute the source code.											#
#  See http://www.gnu.org/licenses/gpl.html for the full license.			#
#############################################################################
# bRO (Brazil)
package Network::Receive::bRO;
use strict;
use Log qw(warning);
use base 'Network::Receive::ServerType0';


# Sync_Ex algorithm developed by Fr3DBr

sub new {
	my ($class) = @_;
	my $self = $class->SUPER::new(@_);
	
	my %packets = (
		'0097' => ['private_message', 'v Z24 V Z*', [qw(len privMsgUser flag privMsg)]], # -1
);
# Sync Ex Reply Array 
	$self->{sync_ex_reply} = {
	'0922', '095E',	'085B', '0867',	'0882', '0888',	'0938', '0920',	'093D', '0898',	'0868', '0362',	'089E', '0929',	'0963', '088B',	'088A', '0887',	'093C', '0891',	'0960', '0948',	'092C', '0951',	'0437', '093A',	'096A', '086D',	'0886', '0941',	'0926', '08A8',	'0864', '0896',	'0934', '086E',	'0880', '088F',	'088C', '094A',	'0917', '0964',	'08AD', '0942',	'0877', '0367',	'085F', '0950',	'0961', '0862',	'089F', '0957',	'08AB', '0924',	'094D', '07E4',	'0366', '086A',	'0954', '085D',	'08A4', '0876',	'0893', '08A3',	'0802', '092F',	'092B', '0947',	'0815', '0884',	'0863', '0281',	'083C', '0967',	'089D', '0943',	'0939', '0936',	'0364', '0202',	'0932', '0962',	'0835', '0940',	'095A', '0817',	'0838', '0360',	'092E', '087F',	'0365', '08A5',	'0438', '0919',	'0969', '023B',	'085A', '0965',	'087B', '092D',	'0937', '089C',	'0952', '08AA',	'0931', '0946',	'0897', '0885',	'0959', '0958',	'0956', '0861',	'095C', '0925',	'087E', '0881',	'0436', '094B',	'085E', '095B',	'0953', '0944',	'08A6', '0811',	'0361', '089A',	'022D', '0873',	'091C', '0870',	'0968', '0949',	'08AC', '0878',	'0875', '0874',	'0369', '095D',	'0872', '092A',	'0933', '0865',	'0899', '0894',	'091D', '02C4',	'035F', '087A',	'088D', '0869',	'0879', '089B',	'093F', '091E',	'0892', '08A9',	'086F', '0935',	'07EC', '087C',	'0363', '086C',	'0860', '0889',	'0928', '088E',	'0945', '091B',
	};
	
	foreach my $key (keys %{$self->{sync_ex_reply}}) { $packets{$key} = ['sync_request_ex']; }
	foreach my $switch (keys %packets) { $self->{packet_list}{$switch} = $packets{$switch}; }
	return $self;
}

sub items_nonstackable {
	my ($self, $args) = @_;

	my $items = $self->{nested}->{items_nonstackable};

	if($args->{switch} eq '00A4' || $args->{switch} eq '00A6' || $args->{switch} eq '0122') {
		return $items->{type4};
	} elsif ($args->{switch} eq '0295' || $args->{switch} eq '0296' || $args->{switch} eq '0297') {
		return $items->{type4};
	} elsif ($args->{switch} eq '02D0' || $args->{switch} eq '02D1' || $args->{switch} eq '02D2') {
		return  $items->{type4};
	} else {
		warning("items_nonstackable: unsupported packet ($args->{switch})!\n");
	}
}

*parse_quest_update_mission_hunt = *Network::Receive::ServerType0::parse_quest_update_mission_hunt_v2;
*reconstruct_quest_update_mission_hunt = *Network::Receive::ServerType0::reconstruct_quest_update_mission_hunt_v2;

1;
