# vrespiti

Scrape xe.gr to find a house to rent the Linux shell way.

## Why ?

- Since xe.gr offers the ability to subscribe to searches and send you emails, why does this script exist ?
- Most people who rent houses don't categorize their properties very well, especially regarding heating. It is
very common to add the type of heating, "αυτόνομη θέρμανση" or "κεντρική θέρμανση" inside the description and not
as a selectable filter. On the other hand xe.gr doesn't allow you to filter based on keywords inside the
descriptions of ads, so you end up opening useless URLs just to find out they have "κεντρική θέρμανση" that you
don't want.

And because writing a script in bash to parse html as json sounds cool.

## Requirements

 * A Linux box capable of sending emails.
 * Install [pup](https://github.com/ericchiang/pup)
 * Install jq and mailx (apt install jq bsd-mailx)

## How to use

 * Go to xe.gr and create your own filter for houses to rent. Choose whatever filtering criteria you want.
 * Get the URL from your browser and place it inside vresspiti.sh
 * Adjust RECIPIENTS of the emails to be sent.
 * Adjust WORK_PATH to a directory that the script can write files.
 * Create a cron entry to run the shell script as often as you want.
 * You might want to wrap the shell script with torsocks in case xe.gr tries to ban your IP for too many connections.

## Did it work ?

Yeap! I got a great new house using this script ;)

## Similar work

~~I've heard that people have written their own versions of this in php and python but I'm not aware of any public versions.~~

[xenotifier](https://github.com/jkakavas/xenotifier)
