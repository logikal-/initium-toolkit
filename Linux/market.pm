use strict;
use warnings;
use MIME::Base64;
use LWP::UserAgent::Determined;
use HTTP::Cookies;
use MIME::Base64;
use Term::ANSIColor;
use Exporter;

our @ISA= qw( Exporter );

our @EXPORT_OK = qw( market );
our @EXPORT = qw( market );

my $lg = "ICBfX19fXyAgICAgICBfIF8gICBfICAgICAgICAgICAgICAgIF9fX19fICAgICAgICAgICAgXyBfICAgICAgICAgICAgICAgDQogIFxfICAgXF8gX18gKF8pIHxfKF8pXyAgIF8gXyBfXyBfX18vX18gICBcX19fICAgX19fIHwgfCB8X18gICBfX19fXyAgX18NCiAgIC8gL1wvICdfIFx8IHwgX198IHwgfCB8IHwgJ18gYCBfIFwgLyAvXC8gXyBcIC8gXyBcfCB8ICdfIFwgLyBfIFwgXC8gLw0KL1wvIC9fIHwgfCB8IHwgfCB8X3wgfCB8X3wgfCB8IHwgfCB8IC8gLyB8IChfKSB8IChfKSB8IHwgfF8pIHwgKF8pID4gIDwgDQpcX19fXy8gfF98IHxffF98XF9ffF98XF9fLF98X3wgfF98IHxfXC8gICBcX19fLyBcX19fL3xffF8uX18vIFxfX18vXy9cX1wNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEhhbmQgY29kZWQgd2l0aCBsb3ZlIC0gRnJleWph";

sub ClearScr()
{
    system $^O eq 'MSWin32' ? 'cls' : 'clear';
    print colored(decode_base64($lg)."\n\n", 'bold yellow');
}

sub market()
{
    keepbuying:
    my $cookie_jar = HTTP::Cookies->new(
    file => "initium-cookie.dat",
    autosave => 1,
    ignore_discard=> 1,
    ) or die "Unable to access cookie file: $!";
    my $browser = LWP::UserAgent::Determined->new( requests_redirectable => [ 'GET', 'HEAD', 'POST' ] );
    $browser->cookie_jar($cookie_jar);
    $browser->timing("1,3,6");
    $browser->agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36");
    my $currentlocation;
    my $verify;

    print "[+] Checking our current location\n";
    my $url = "http://playinitium.com/main.jsp";
    my $response = $browser->get($url) or die;

    #retrieve our current location
    if($response->is_success)
    {
        if($response->decoded_content =~ m/location above-page-popup'><a href='main.jsp'>(.*)<\/a><\/div>/)
        {
            $currentlocation = $1;      
        } else { die "Couldn't get current location\n"; }
        if($response->decoded_content =~ m/window.verifyCode = "(.*)"/)
        {
            $verify = $1;
        } else { die "Couldn't get verify\n"; }
                                
    } else { die $response->status_line; }



    print "\nEnter item name or partial name, ie. \"troll\":\n";
    my $itemName = <STDIN>;
    ClearScr();
    chomp($itemName);
    print "\nMaximum dex pen? (Enter a number or press enter):\n";
    my $dexPenMaximum = <STDIN>;
    chomp($dexPenMaximum);
    print "Enumerating items containing \"$itemName\" in all stores in $currentlocation...\n";
    print "...............................................................................\n";
    $url = "https://www.playinitium.com/locationmerchantlist.jsp";
    $response = $browser->get($url);
    my $counter = 0;
    my $cntMultiplier = 1;
    my @saleItemIdArray = ();
    my @itemIdArray = ();
    my @characterIdArray = ();
    if($response->is_success)
    {
	my $content = $response->decoded_content;
	foreach($content =~ m/viewStore\((\d{14,18})\)/g)
	{
		if($counter>=10*$cntMultiplier)
		{ 
			print "\nMore than ".(10*$cntMultiplier)." $itemName found so far, continue? (y/n)\n[n]: "; 
			my $shouldWeContinue = <STDIN>; 
			chomp($shouldWeContinue);
			if(!($shouldWeContinue eq "y"))
			{
                            last; 
		    	}
			$cntMultiplier++;
		}
		my $characterId = $_;
		
		$url = "https://www.playinitium.com/odp/ajax_viewstore.jsp?characterId=$characterId";
		$response = $browser->get($url);
		if($response->is_success)
		{
			my $content2 = $response->decoded_content;
			while($content2 =~ m/viewitemmini.jsp\?itemId=(\d{14,18})'><img src='(.{1,200}?)>(.{0,40}?)<\/a> - <a onclick='storeBuyItemNew\(event, "(.{0,25}?)$itemName(.{0,25}?)","([\d,]{1,12})",(\d{14,18}),(\d{14,18}),/sgi)
			{
				my $tempItemName = $3;
				my $itemId = $1; my $itemPrice = $6; my $saleItemId = $8;
				if($itemId && $itemPrice && $saleItemId)
				{
					$url = "http://www.playinitium.com/viewitemmini.jsp?itemId=$itemId";
					my $response = $browser->get($url);
					if($response->is_success)
					{
						$saleItemIdArray[$counter] = $saleItemId;
						$itemIdArray[$counter] = $itemId;
						$characterIdArray[$counter] = $characterId;
						print "\n\t$counter. "; #[ $itemName ]\n";
						my $content3 = $response->decoded_content;
						$content3 =~ s/<!--  Comparisons -->(.*)//s;
						print "\t[ $tempItemName ] ";
						if(length($tempItemName) < 19 ) { print "\t"; }
						print "\tItem price: $itemPrice ";
						$itemPrice =~ s/,//g; if($itemPrice < 100){ print "\t"; } #even it out
						if($content3 =~ m/Dexterity penalty: <div class='main-item-subnote'>([\d\-\.]{1,4})%/)
						{
                                                        my $dexPen = $1;
                                                        if($dexPenMaximum)
                                                        {
                                                            if($dexPen > $dexPenMaximum)
                                                            {
                                                                print color('red')."\r\t[ Item above maximum dex pen ]                                     ".color('reset');
                                                                next;
                                                            }
                                                        }
							print "\tDex pen: $dexPen% ";
						}
						$itemPrice =~ s/,//;
						if($content3 =~ m/Durability: <div class='main-item-subnote'>(\d{1,6})\/(\d{1,6})<\/div>/)
						{
							print "\tDura: $1/$2\tgp/dura: "; printf("%.2f", ($itemPrice/$1)); print " ";
						}
						if($content3 =~ m/([\d\.]{1,4}?) max dmg, ([\d\.]{1,8}?) avg dmg/)
						{
							print "\t$1 max dmg/$2 avg dmg";
						}
						if($content3 =~ m/Block chance: <div class='main-item-subnote'>(\d{1,3})%/)
						{
							if($1 > 30)
							{
								print "\tBlock chance: $1% ";
								print "(";
								if($content3 =~ m/Block bludgeoning: <div class='main-item-subnote'>(Excellent|Good|Average|Poor|Minimal|None)<\/div>/s)
								{ print "Block bl/pi/sl: ". substr($1,0,4);
								}
								if($content3 =~ m/Block piercing: <div class='main-item-subnote'>(Excellent|Good|Average|Poor|Minimal|None)<\/div>/s)
								{ print "/".substr($1,0,4);
								}
								if($content3 =~ m/Block slashing: <div class='main-item-subnote'>(Excellent|Good|Average|Poor|Minimal|None)<\/div>/s)
								{ print "/".substr($1,0,4);
								}
								print ")";
							}
						}
						if($content3 =~ m/Damage reduction: <div class='main-item-subnote'>(\d{1,3})<\/div>/)
							{
								print "\tDmg reduc: $1";
							}
							print "\n";
							$counter++;
						}
					}
				}
			} else { die $response->status_line; }
		}
		if($counter == 0)
		{ print "No items found.\n"; }
		else
		{
			print "\nEnter item #s to buy (separated by spaces) or press enter to search again:\n";
			my $itemToBuy = <STDIN>;
			chomp($itemToBuy);
			if($itemToBuy eq "")
			{ goto keepbuying; }
			my $singleItemToBuy;
			while($itemToBuy =~ m/(\d{1,2})([ ]?)/g)
			{
				$singleItemToBuy = $1;
				print "\nItem #: $singleItemToBuy\n";
				if($saleItemIdArray[$singleItemToBuy] && $itemIdArray[$singleItemToBuy])
				{
					$url = "http://www.playinitium.com/viewitemmini.jsp?itemId=".$itemIdArray[$singleItemToBuy];
					my $response = $browser->get($url);
					if($response->is_success)
					{
						$content = $response->decoded_content;
						if($content =~ m/Dexterity penalty: <div class='main-item-subnote'>(\d{1,2})%/)
						{
							print "\tDex pen: $1%\n";
						}
						if($content =~ m/Block chance: <div class='main-item-subnote'>(\d{1,3})%/)
						{
							print "\tBlock chance: $1\n";
						}
						if($content =~ m/Durability: <div class='main-item-subnote'>(\d{1,6})\/(\d{1,6})<\/div>/)
						{
							print "\tDurability: $1/$2\n";
						}

					} else { print "\tFailed to fetch item information\n"; }
					print "\nConfirm, buy this $itemName? (y/n)\n[n]: ";
					my $confirmPurchase = <STDIN>;
					chomp($confirmPurchase);
					if($confirmPurchase eq "y")
					{
						#print "Would have purchased item id ".$itemIdArray[$itemToBuy]." with sale id ".$saleItemIdArray[$itemToBuy]." from char ".$characterIdArray[$itemToBuy]."\n";
						$url = "http://www.playinitium.com/cmd?cmd=StoreBuyItem&saleItemId=".$saleItemIdArray[$singleItemToBuy]."&characterId=".$characterIdArray[$singleItemToBuy]."&v=".$verify;
						$response = $browser->get($url);
						if($response->is_success)
						{
							if($response->decoded_content =~ m/^{"javascriptResponse":"None","callbackData"/)
							{
								print "[+] Purchase successful\n";
						
							} 
                                                        else 
                                                        { 
                                                            print "Purchase failed for some reason\n".$response->status_line."\n";
                                                            if($response->decoded_content =~ m/enough funds/) 
                                                            { 
                                                                print "Not enough gold\n"; 
                                                            }
                                                            else 
                                                            {
                                                                print $response->decoded_content; 
                                                            }
                                                        }
						} else { die("Error 5502: Unable to purchase item: $!\n".$response->status_line."\n"); }
					}
				}
			}
		}
		print "\nSearch for another item? (y/n)\n[y]: ";
		my $purchaseNewItem = <STDIN>;
		chomp($purchaseNewItem);
		if(!($purchaseNewItem eq "n"))
		{
			goto keepbuying;
		} else { die(); }
	} else { die("Couldn't get local merchant list\n"); }
}
