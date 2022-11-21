%web_drop_table(WORK.BALDY);
FILENAME BALDY '/home/u62732152/sasuser.v94/Baldy.csv';

PROC IMPORT DATAFILE=BALDY
	DBMS=CSV
	OUT=WORK.BALDY;
	GETNAMES=YES;
RUN;

/*Make new variables to transform measurements from inches to millimeters.*/
DATA BALDY;
	SET WORK.BALDY;
	LuxuriantMM = Luxuriant * 25.4;
	PlaceboMM = Placebo * 25.4;
	BaldBeGoneMM = BaldBeGone * 25.4;
	HairyGoodnessMM = HairyGoodness * 25.4;
RUN;

PROC SGPLOT DATA=WORK.BALDY;
	HISTOGRAM LuxuriantMM;
	TITLE  "Luxuriant Hair Growth Distribution";
	YAXIS LABEL="Millimeters (mm)";
RUN;

PROC SGPLOT DATA=WORK.BALDY;
	HISTOGRAM PlaceboMM;
	TITLE "Luxuriant Placebo Hair Growth Distribution";
	YAXIS LABEL="Millimeters (mm)";
RUN;

PROC SGPLOT DATA=WORK.BALDY;
	HISTOGRAM BaldBeGoneMM;
	TITLE "BaldBeGone Hair Growth Distribution";
	YAXIS LABEL="Millimeters (mm)";
RUN;

PROC SGPLOT DATA=WORK.BALDY;
	HISTOGRAM HairyGoodnessMM;
	TITLE "HairyGoodness Hair Growth Distribution";
	YAXIS LABEL="Millimeters (mm)";
RUN;

/*Compare medians of each distribution, since right-skew means that median is the most helpful statistic.*/
PROC MEANS DATA=WORK.BALDY MEDIAN;
	VAR LuxuriantMM;
	VAR PlaceboMM;
	VAR BaldBeGoneMM;
	VAR HairyGoodnessMM;
RUN;

/*Comparison of age/effect relationship between Luxuriant and the placebo.*/
PROC SGPLOT DATA=WORK.BALDY;
	SCATTER X=AgeLuxuriant Y=LuxuriantMM;
	SCATTER X=AgePlacebo Y=PlaceboMM;
	TITLE "Age and Treatment Interaction Comparison Between Luxuriant and the Placebo";
	XAXIS LABEL="Age";
	YAXIS LABEL="Millimeters (mm) of Hair Growth";
RUN;

PROC SGSCATTER DATA=WORK.BALDY;
	PLOT LuxuriantMM*AgeLuxuriant;
	TITLE "The Relationship Between Age and Treatment for Luxuriant";
RUN;

PROC SGSCATTER DATA=WORK.BALDY;
	PLOT PlaceboMM*AgePlacebo;
	TITLE "The Relationship Between Age and Treatment for Luxuriant Placebo";
RUN;

PROC SGSCATTER DATA=WORK.BALDY;
	PLOT BaldBeGoneMM*AgeBaldBeGone;
	TITLE "The Relationship Between Age and Treatment for BaldBeGone";
RUN;

PROC SGSCATTER DATA=WORK.BALDY;
	PLOT HairyGoodnessMM*AgeHairyGoodness;
	TITLE "The Relationship Between Age and Treatment for HairyGoodness";
RUN;

/*Double-checking if there is a relationship between age and results for the product we are most interested in.*/
PROC GLM DATA=WORK.BALDY;
	MODEL LuxuriantMM=AgeLuxuriant;
RUN;