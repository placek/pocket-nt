1d

s/\bGen\b/10/g
s/\bExod\b/20/g
s/\bLev\b/30/g
s/\bNum\b/40/g
s/\bDeut\b/50/g
s/\bJosh\b/60/g
s/\bJudg\b/70/g
s/\bRuth\b/80/g
s/\b1Sam\b/90/g
s/\b2Sam\b/100/g
s/\b1Kgs\b/110/g
s/\b2Kgs\b/120/g
s/\b1Chr\b/130/g
s/\b2Chr\b/140/g
s/\bEzra\b/150/g
s/\bNeh\b/160/g
s/\bEsth\b/190/g
s/\bJob\b/220/g
s/\bPs\b/230/g
s/\bProv\b/240/g
s/\bEccl\b/250/g
s/\bSong\b/260/g
s/\bIsa\b/290/g
s/\bJer\b/300/g
s/\bLam\b/310/g
s/\bEzek\b/330/g
s/\bDan\b/340/g
s/\bHos\b/350/g
s/\bJoel\b/360/g
s/\bAmos\b/370/g
s/\bObad\b/380/g
s/\bJonah\b/390/g
s/\bMic\b/400/g
s/\bNah\b/410/g
s/\bHab\b/420/g
s/\bZeph\b/430/g
s/\bHag\b/440/g
s/\bZech\b/450/g
s/\bMal\b/460/g
s/\bMatt\b/470/g
s/\bMark\b/480/g
s/\bLuke\b/490/g
s/\bJohn\b/500/g
s/\bActs\b/510/g
s/\bRom\b/520/g
s/\b1Cor\b/530/g
s/\b2Cor\b/540/g
s/\bGal\b/550/g
s/\bEph\b/560/g
s/\bPhil\b/570/g
s/\bCol\b/580/g
s/\b1Thess\b/590/g
s/\b2Thess\b/600/g
s/\b1Tim\b/610/g
s/\b2Tim\b/620/g
s/\bTitus\b/630/g
s/\bPhlm\b/640/g
s/\bHeb\b/650/g
s/\bJas\b/660/g
s/\b1Pet\b/670/g
s/\b2Pet\b/680/g
s/\b1John\b/690/g
s/\b2John\b/700/g
s/\b3John\b/710/g
s/\bJude\b/720/g
s/\bRev\b/730/g
s/\bTob\b/170/g
s/\bJdt\b/180/g
s/\b1Mch\b/462/g
s/\b2Mch\b/464/g
s/\bMdr\b/270/g
s/\bSyr\b/280/g
s/\bBa\b/320/g

s/\./,/g
s/\t/,/g
s/,([^,]*)$/,,,,\1/
/[0-9]-/s/,,,,/,/
/[0-9]-/s/-/,/