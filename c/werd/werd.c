	
	/* introductory C program 
	
	   implements (a subset of) the Unix wc command  --  reports character, 
	   word and line counts; in this version, the "file" is read from the 
	   standard input, since we have not covered C file manipulation yet, 
	   so that we read a real file can be read by using the Unix `<'
	   redirection feature */
	
	
	#define MaxLine 200  
	
	
	char Line[MaxLine];  /* one line from the file */
	
	
	int NChars = 0,  /* number of characters seen so far */
	    NWords = 0,  /* number of words seen so far */
	    NLines = 0,  /* number of lines seen so far */
	    LineLength;  /* length of the current line */ 
	
	
	PrintLine()  /* for debugging purposes only */
	
	{  int I;
	
	   for (I = 0; I < LineLength; I++) printf("%c",Line[I]);
	   printf("\n");
	}
	
	
	int WordCount()
	
	/* counts the number of words in the current line, which will be taken
	   to be the number of blanks in the line, plus 1 (except in the case 
	   in which the line is empty, i.e. consists only of the end-of-line 
	   character); this definition is not completely general, and will be
	   refined in another version of this function later on */
	
	{  int I,NBlanks = 0;  
	
	   for (I = 0; I < LineLength; I++)  
	   if (Line[I] == ' ') NBlanks++;
	
	   if (LineLength > 1) return NBlanks+1;
	   else return 0;
	}
	
	
	int ReadLine()
	
	/* reads one line of the file, returning also the number of characters
	   read (including the end-of-line character); that number will be 0
	   if the end of the file was reached */
	
	{  char C;  int I;
	
	   if (scanf("%c",&C) == -1) return 0;
	   Line[0] = C;
	   if (C == '\n') return 1; 
	   for (I = 1; ; I++) {
	      scanf("%c",&C);     
	      Line[I] = C;  
	      if (C == '\n') return I+1;
	   }  
	}
	
	
	UpdateCounts()
	
	{  NChars += LineLength;
	   NWords += WordCount();
	   NLines++;
	}
	 
	 
	main()  
	
	{  while (1)  {
	      LineLength = ReadLine();
	      if (LineLength == 0) break;
	      UpdateCounts();
	   }
	   printf("%d %d %d\n",NChars,NWords,NLines);
	}

