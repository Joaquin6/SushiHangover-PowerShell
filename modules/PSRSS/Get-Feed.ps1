function Get-Feed {
    <#
    .Synopsis
    Gets RSS feeds.

    .Description
    The Get-Feed function gets objects that represent the RSS feeds to which the system is subscribed. 

    The feed objects have useful properties, such LastDownloadTime, UnreadItemCount, Link (to the Web site) and Image (path to images), and methods, such as Delete, GetItem, Move, and AsyncDownload. You can also pipe the object that Get-Feed returns to other functions, such as Remove-Feed.

    .Parameter Feed
    Gets only the specified RSS feeds. The default is all feeds in the system. Enter the name of a feed or a name pattern. Wildcard characters are permitted. 

    .Notes
    The Get-Feed function is exported by the PSRSS module. For more information, see about_PSRSS_Module.

    The Get-Feed function uses the Microsoft.FeedsManager COM object.

    .Example
    Get-Feed

    .Example
    Get-Feed "Windows PowerShell Blog"

    .Example
    Get-Feed *PowerShell*

    .Example
    Get-Feed | format-table Name, LastDownloadTime, ItemCount, UnreadItemCount, MaxItemCount

    .Example
    # Sync an RSS feed.
    (Get-Feed "Windows PowerShell Blog").Download()

    .Example
    # Sync all RSS feeds.
    get-feed | foreach {$_.asyncdownload()}

    .Example
    function Get-TodaysPosts
    {
        $feeds = Get-Feed
        foreach ($feed in $feeds) 
        {
          $name  =  $feed.name
          $todaysPosts = $feed.Items | where {$_.pubdate -eq (get-date).date}
          if ($todaysPosts)
              { write-host $name; $todaysPosts | sort pubdate, title |  ft title, pubdate }
        }
    }

    .Link
    about_PSRSS_Module

    .Link
    "Windows RSS Platform" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684701(VS.85).aspx

    .Link
    "Microsoft.FeedsManager Object" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684749(VS.85).aspx


    .Link
    "Windows RSS Platform" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684701(VS.85).aspx

    .Link
    "Microsoft.FeedsManager Object" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684749(VS.85).aspx

    #>
    param(
        $Feed = "*", 
        $Folder
    )     

    if (! $folder) {
        $feedsManager = New-Object -ComObject Microsoft.FeedsManager   
        $folder = $feedsManager.RootFolder     
    }
    
    $folder.Feeds |
        Where-Object { 
            ($_.Title -like "$feed") -or ($_.Name -like "$feed")
        } | Foreach-Object {
            $_ 
        }
    $folder.Subfolders | 
        Foreach-Object {
            Get-Feed $feed -folder $_
        }
}