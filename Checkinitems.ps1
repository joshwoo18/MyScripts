$items = get-content "C:\Test\CheckIn"

foreach($item in $items)
{

    if( $itemFile.CheckOutStatus -ne "None" )
    { 
        $itemFile.CheckIn("Automatic CheckIn. (Administrator)")
    }
	
}
