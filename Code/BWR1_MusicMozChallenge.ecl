//#OPTION('obfuscateOutput', TRUE);
IMPORT $;
MozMusic := $.File_Music.MozDS;

//display the first 150 records

OUTPUT(CHOOSEN(MozMusic, 150), NAMED('Moz_MusicDS'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Count all the records in the dataset:

output(COUNT(MozMusic), named('CountAllRecords'));

//Result: Total count is 136510

//*********************************************************************************
//*********************************************************************************
//Challenge: 

//Sort by "name",  and display (OUTPUT) the first 50(Hint: use CHOOSEN):

//You should see a lot of songs by NSync 

SortedNames := SORT(MozMusic, name);
OUTPUT(CHOOSEN(SortedNames, 50), NAMED('SortByName'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count total songs in the "Rock" genre and display number:

tempRock := MOZMUSIC(genre='Rock');
//Result should have 12821 Rock songs

//Display your Rock songs (OUTPUT):
OUTPUT(tempRock, NAMED('RockSongs'));
output(Count(tempRock), named ('RockSongsCount'));
//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count how many songs was released by Depeche Mode between 1980 and 1989

//Filter ds for "Depeche_Mode" AND releasedate BETWEEN 1980 and 1989

// Count and display total
//Result should have 127 songs 

tempDepeche := MozMusic((name = 'Depeche_Mode'),(releasedate >= '1980'),(releasedate <= '1989'));
output(COUNT(tempDepeche), named('CountDepeche_Mode'));
OUTPUT(tempDepeche, NAMED('Depeche_Mode'));

//Bonus points: filter out duplicate tracks (Hint: look at DEDUP):


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Who sang the song "My Way"?
//Filter for "My Way" tracktitle

// Result should have 136 records 

//Display count and result 

SangMyWay := MozMusic(tracktitle = 'My Way');
output(Count(SangMyWay), named('CountMyWay'));
OUTPUT(CHOOSEN(SangMyWay, 127), NAMED('SangMyWay'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//What song(s) in the Music Moz Dataset has the longest track title in CD format?

//Get the longest description (tracktitle) field length in CD "formats"


//Filter dataset for tracktitle with the longest value


//Display the result

//Longest track title is by the "The Brand New Heavies"               

CDFormat := MozMusic(formats = 'CD');
longtitle := Max(CDFormat, length(TRIM(tracktitle)));
SortedLength := CDFormat(length(TRIM(tracktitle)) = longtitle);
OUTPUT(SortedLength, NAMED('LongestTitle'));

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display all songs produced by "U2" , SORT it by title.

//Filter track by artist
U2Songs := MozMusic(name = 'U2');

//Sort the result by tracktitle
Sortedu2 := SORT(U2Songs, tracktitle);

//Output the result
OUTPUT(CHOOSEN(Sortedu2, 190), NAMED('U2Songs'));

//Count result 
output(COUNT(Sortedu2), named('CountU2Songs'));

//Result has 190 records


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count all songs where guest musicians appeared 

//Hint: Think of the filter as "not blank" 

//Filter for "guestmusicians"

GuestSort := MozMusic(guestmusicians != '');    

//Display Count result

output(Count(GuestSort), named('CountGuestMusicians'));

//Result should be 44588 songs  


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new recordset which only has "Track", "Release", "Artist", and "Year"
// Get the "track" value from the MusicMoz TrackTitle field
// Get the "release" value from the MusicMoz Title field
// Get the "artist" value from the MusicMoz Name field
// Get the "year" value from the MusicMoz ReleaseDate field

//Result should only have 4 fields. 

//Hint: First create your new RECORD layout  

createRecord := RECORD
  STRING track;
  STRING release;
  STRING artist;
  STRING year;
END;

//Next: Standalone Transform - use TRANSFORM for new fields.


//Use PROJECT, to loop through your music dataset

newRecord := PROJECT(MozMusic, TRANSFORM(createRecord, 
  SELF.track := LEFT.tracktitle;
  SELF.release := LEFT.title;
  SELF.artist := LEFT.name;
  SELF.year := LEFT.releasedate;
  SELF := LEFT;));

// Display result  

OUTPUT(newRecord, NAMED('NewRecord')); 

//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************

//Challenge: 
//Display number of songs per "Genre", display genre name and count for each 

//Hint: All you need is a 2 field TABLE using cross-tab

//Display the TABLE result      


//Count and display total records in TABLE

crossLayout := RECORD
  MozMusic.genre;
  TotalSongs := COUNT(GROUP);
END;

T1 := TABLE(MozMusic, crossLayout, genre);
OUTPUT(T1, NAMED('GenreCount'));

//Result has 2 fields, Genre and TotalSongs, count is 1000

//*********************************************************************************
//*********************************************************************************
//What Artist had the most releases between 2001-2010 (releasedate)?

//Hint: All you need is a cross-tab TABLE 

//Output Name, and Title Count(TitleCnt)

//Filter for year (releasedate)

//Cross-tab TABLE

crossLayout2 := RECORD
    MozMusic.name;
    TitleCnt := COUNT(GROUP);
END;

t2 := TABLE(MozMusic((releasedate >= '2001'),(releasedate <= '2010')), crossLayout2, name);
t3 := SORT(t2, - TitleCnt);
OUTPUT(CHOOSEN(t3, 1), NAMED('TopArtist'));

//Display the result      
