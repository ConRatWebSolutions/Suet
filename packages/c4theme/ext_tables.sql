#
# Add SQL definition of database tables
#

#
# Additional columns for tt_content (video_content, team_content)
#
CREATE TABLE tt_content (
    tx_c4theme_youtube_id varchar(20) DEFAULT '' NOT NULL,
    tx_c4theme_email varchar(255) DEFAULT '' NOT NULL
);

#
# Table structure for table 'tx_c4theme_contact'
#
 CREATE TABLE tx_c4theme_contact (
  `uid` int(11) NOT NULL,
  `pid` int(11) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `subject` varchar(240) NOT NULL,
  `message` text NOT NULL,
  `crdate` int(11) NOT NULL,
  `tstamp` int(11) NOT NULL,
  `hidden` smallint(5) UNSIGNED NOT NULL,
  
  PRIMARY KEY (uid)
);


 