#OPTION('obfuscateOutput', TRUE);
IMPORT $;
MozMusic  := $.File_Music.MozDS;
MSDMusic  := $.File_Music.MSDDS;
SpotMusic := $.File_Music.SpotDS;

// Combine the three datasets into a composite dataset using a common record format:

CombMusicLayout := RECORD
 UNSIGNED RECID;
 STRING   SongTitle;
 STRING   AlbumTitle;
 STRING   Artist;
 STRING   Genre;
 STRING4  ReleaseYear;
 STRING4  Source; //MOZ,MSD,SPOT
END;

OUTPUT('ToDo');

newMoz := PROJECT(MozMusic, TRANSFORM(CombMusicLayout, 
  SELF.RECID:= (INTEGER) LEFT.id;
  SELF.SongTitle := LEFT.tracktitle;
  SELF.AlbumTitle := LEFT.title;
  SELF.Artist := LEFT.name;
  SELF.Genre := LEFT.genre;
  SELF.ReleaseYear := LEFT.releasedate;
  Self.Source := 'MOZ';
  SELF := LEFT;
  ));

newMSD := PROJECT(MSDMusic, TRANSFORM(CombMusicLayout, 
  SELF.RECID:= LEFT.RecID;
  SELF.SongTitle := LEFT.title;
  SELF.AlbumTitle := LEFT.release_name;
  SELF.Artist := LEFT.artist_name;
  SELF.Genre := 'N/A';
  SELF.ReleaseYear := (STRING) LEFT.year;
  Self.Source := 'MSD';
  SELF := LEFT;
  ));

newSpot := Project(SpotMusic, TRANSFORM (CombMusicLayout,
  SELF.RECID:= LEFT.RecID;
  SELF.SongTitle := LEFT.track_name;
  SELF.AlbumTitle := 'N/A';
  SELF.Artist := LEFT.artist_name;
  SELF.Genre := LEFT.genre;
  SELF.ReleaseYear := (STRING) LEFT.year;
  Self.Source := 'SPOT';
  SELF := LEFT;

));

CombinedMusic := newMoz + newMSD + newSpot;
FinalMusic := DEDUP(CombinedMusic, SongTitle);
SortedFinalMusic := SORT(FinalMusic, SongTitle);
Output(SortedFinalMusic, NAMED('FinalMusicList'));
Count(SortedFinalMusic);

//After doing this, create different playlists by Year and/or genre! Music is Life! 