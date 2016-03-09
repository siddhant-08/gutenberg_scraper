# gutenberg_scraper

gutenberg_scraper is a R function to scrape texts from the gutenberg project.
It automatically removes the disclaimers and the license at the end of the text.

The disclaimers look like this-
<\<THIS ELECTRONIC VERSION OF THE COMPLETE WORKS OF WILLIAM
SHAKESPEARE IS COPYRIGHT 1990-1993 BY WORLD LIBRARY, INC., AND IS
PROVIDED BY PROJECT GUTENBERG ETEXT OF ILLINOIS BENEDICTINE COLLEGE
WITH PERMISSION.  ELECTRONIC AND MACHINE READABLE COPIES MAY BE
DISTRIBUTED SO LONG AS SUCH COPIES (1) ARE FOR YOUR OR OTHERS
PERSONAL USE ONLY, AND (2) ARE NOT DISTRIBUTED OR USED
COMMERCIALLY.  PROHIBITED COMMERCIAL DISTRIBUTION INCLUDES BY ANY
SERVICE THAT CHARGES FOR DOWNLOAD TIME OR FOR MEMBERSHIP.>\>

Also at the end of each text is a full license which was also removed.

The default text is [The complete works of William Shakespeare](http://www.gutenberg.org/cache/epub/100/pg100.html)

In the default text 220 disclaimers were found which were all consequently removed.
