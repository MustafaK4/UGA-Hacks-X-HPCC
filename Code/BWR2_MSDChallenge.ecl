﻿//#OPTION('obfuscateOutput', TRUE);
IMPORT $;
MSDMusic := $.File_Music.MSDDS;

//display the first 150 records

OUTPUT(CHOOSEN(MSDMusic, 150), NAMED('Raw_MusicDS'));

//*********************************************************************************
//*********************************************************************************
 
//                                CATEGORY ONE 

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Reverse Sort by "year" and count your total music dataset and display the first 50

//Result: Total count is 1000000

//Reverse sort by "year"
CisuMDSM := SORT(MSDMusic, -year);

//display the first 50


//Count and display result
OUTPUT(CHOOSEN(CisuMDSM, 50), NAMED('Music_Backwards'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display first 50 songs by of year 2010 and then count the total 

//Result should have 9397 songs for 2010

//Filter for 2010 and display the first 50
MusicOf2010 := MSDMusic(year = 2010);
OUTPUT(CHOOSEN(MusicOf2010, 50), NAMED('Music2010First50'));

//Count total songs released in 2010:
CountAll := COUNT(MSDMusic);
OUTPUT(CHOOSEN(MusicOf2010, CountAll), NAMED('Music2010Total'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count how many songs was produced by "Prince" in 1982

//Result should have 4 counts

//Filter ds for "Prince" AND 1982

//Count and print total 

Prince1982 := MSDMusic(year = 1982, artist_name = 'Prince');
CountPrince := COUNT(Prince1982);
OUTPUT(CHOOSEN(Prince1982, CountPrince), NAMED('PrinceMusicIn1982'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Who sang "Into Temptation"?

// Result should have 3 records

//Filter for "Into Temptation"

//Display result 

IntoTemptationWho := MSDMusic(title = 'Into Temptation');
CountIntoTemptation := COUNT(IntoTemptationWho);
OUTPUT(CHOOSEN(IntoTemptationWho, CountIntoTemptation), NAMED('IntoTemptation'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Sort songs by Artist and song title, output the first 100

//Result: The first 10 records have no artist name, followed by "- PlusMinus"                                     

//Sort dataset by Artist, and Title
ArtistSortation := SORT(MSDMusic, artist_name, title);


//Output the first 100
OUTPUT(CHOOSEN(ArtistSortation, 100), NAMED('SortedArtistSong'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//What is the hottest song by year in the Million Song Dataset?
//Sort Result by Year (filter iut zero Year values)
SortByYear := SORT(MSDMusic, year != 0);

//Result is 

//Get the datasets maximum hotness value
MaxHotness := MAX(MSDMusic, song_hotness);


//Filter dataset for the maxHot value
DatasetMaxFilter := MSDMusic(song_hotness = MaxHotness);
CountEvery := COUNT(DatasetMaxFilter);

//Display the result
OUTPUT(CHOOSEN(DatasetMaxFilter, CountEvery), NAMED('SongWithTheHighestHotScore'));



//*********************************************************************************
//*********************************************************************************

//                                CATEGORY TWO

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display all songs produced by the artist "Coldplay" AND has a 
//"Song Hotness" greater or equal to .75 ( >= .75 ) , SORT it by title.
//Count the total result

//Result has 47 records

//Get songs by defined conditions
ColdplayLargerHotScore := MSDMusic(artist_name = 'Coldplay', song_hotness >= .75);


//Sort the result
ColdplaySort := SORT(ColdplayLargerHotScore, title);


//Output the result


//Count and output result 
ColdplayCount := COUNT(ColdplaySort);
OUTPUT(CHOOSEN(ColdplaySort, ColdplayCount), NAMED('ColdplayResults'));


//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Count all songs where "Duration" is between 200 AND 250 (inclusive) 
//AND "song_hotness" is not equal to 0 
//AND familarity > .9

//Result is 762 songs  

//Hint: (SongDuration BETWEEN 200 AND 250)

//Filter for required conditions
DurationFilter := MSDMusic(duration >= 200, duration <= 250, song_hotness != 0, familiarity > .9);

//Count result
DurationCounter := COUNT(DurationFilter);              

//Display result
OUTPUT(CHOOSEN(DurationFilter, DurationCounter), NAMED('DurationOfSongs'));

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new dataset which only has  "Title", "Artist_Name", "Release_Name" and "Year"
//Display the first 50

//Result should only have 4 columns. 

//Hint: Create your new RECORD layout and use TRANSFORM for new fields. 
//Use PROJECT, to loop through your music dataset


//Standalone Transform 
simpleLayout := record
    string Title;
    string Artist_Name;
    string Release_Name;
    unsigned2 Year;
end;

simpleLayout simpleSet(recordof(MSDMusic) le) := transform
    self.Title := le.title;
    self.Artist_Name := le.artist_name;
    self.Release_Name := le.release_name;
    self.Year := le.year;
end;

//PROJECT
simpleProj := project(MSDMusic, simpleSet(left));

// Display result  
output(simpleProj, named('Simplified_Dataset'));

//*********************************************************************************
//*********************************************************************************

//Challenge: 

// need to filter the songs to only those with some hotness
filteredHotness := MSDMusic(song_hotness!=0, artist_hotness!=0);

//1- What’s the correlation between "song_hotness" AND "artist_hotness"
output(correlation(filteredHotness, song_hotness,  artist_hotness), named('Correlation_Hotness'));


//2- What’s the correlation between "barsstartdev" AND "beatsstartdev"
output(correlation(MSDMusic, barsstartdev,  beatsstartdev), named('Correlation_BeatsBars_Start'));


//Result for hotness = 0.4706972681953097, StartDev = 0.8896342348554744




//*********************************************************************************
//*********************************************************************************

//                                CATEGORY THREE

//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Create a new dataset which only has following conditions
//   *  Column named "Song" that has "Title" values 
//   *  Column named "Artist" that has "artist_name" values 
//   *  New BOOLEAN Column called isPopular, and it's TRUE is IF "song_hotness" is greater than .80
//   *  New BOOLEAN Column called "IsTooLoud" which is TRUE IF "Loudness" > 0
//Display the first 50

//Result should have 4 columns named "Song", "Artist", "isPopular", and "IsTooLoud"


//Hint: Create your new layout and use TRANSFORM for new fields. 
//      Use PROJECT, to loop through your music dataset

//Create the RECORD layout
popLayout := record
    string Song;
    string Artist;
    boolean isPopular;
    boolean isTooLoud;
end;

//Build your TRANSFORM
popLayout popTr(recordof(MSDMusic) le) := transform
    self.Song := le.title;
    self.Artist := le.artist_name;
    self.isPopular := le.song_hotness>0.8;
    self.isTooLoud := le.loudness>0;
end;

//Creating the PROJECT
popSet := project(MSDMusic, popTr(left));

//Display the result
output(popSet, named('Popular_Loud_Music'));
                       
                                              
//*********************************************************************************
//*********************************************************************************
//Challenge: 
//Display number of songs per "Year" and count your total 

//Result has 2 col, Year and TotalSongs, count is 89

//Hint: All you need is a cross-tab TABLE 

yearTable := table(MSDMusic, {year, TotalSongs := count(group)}, year);

//Display the result 
// i'm sorting just cause
output(sort(yearTable, year), named('Year_Counts'));

//Count and display total number of years counted
output(count(yearTable), named('Total_Years'));


//*********************************************************************************
//*********************************************************************************
// What Artist had the overall hottest songs between 2006-2007?
// Calculate average "song_hotness" per "Artist_name" for "Year" 2006 and 2007

// Hint: All you need is a TABLE, and see the TOPN function for your OUTPUT 

// Output the top ten results showing two columns, Artist_Name, and HotRate.

// Filter for year
filtered20067 := MSDMusic(year=2006 or year=2007, song_hotness!=0);

// Create a Cross-Tab TABLE:
hot20067 := table(filtered20067, {artist_name, HotRate := ave(group, song_hotness)}, artist_name);

// Display the top ten results with top "HotRate"      
output(topn(hot20067, 10, -HotRate), named('Wonder_Artists'));
