* To load the data in SPSS, please run the syntax completely by
* - either (a) choose in the menu bar: "Execute/Run", "All"
* - or (b) highlight the overall syntax (ctrl+A) and then click on the
* arrow (run current command).

DATA LIST FREE(TAB)
 /CASE (F8.0)
  SERIAL (A4)
  REF (A4)
  QUESTNNR (A4)
  MODE (A8)
  STARTED (DATETIME)
  IN01_01 (A16)
  IN02_01 (A4)
  IN03 (F3.0)
  IN04_01 (A4)
  QU01 (F3.0)
  QU02 (F3.0)
  QU03 (F3.0)
  QU04 (F3.0)
  QU05 (F3.0)
  QU06 (F3.0)
  QU07 (F3.0)
  QU08 (F3.0)
  RA01_01 (F3.0)
  RA01_02 (F3.0)
  RA01_03 (F3.0)
  RA01_04 (F3.0)
  RA01_05 (F3.0)
  RA01_06 (F3.0)
  RA01_07 (F3.0)
  RA01_08 (F3.0)
  RA01_09 (F3.0)
  RA01_10 (F3.0)
  RA01_11 (F3.0)
  RA01_12 (F3.0)
  RA01_13 (F3.0)
  RA01_14 (F3.0)
  RA01_15 (F3.0)
  RA01_16 (F3.0)
  RA01_17 (F3.0)
  RA01_18 (F3.0)
  RA01_21 (F3.0)
  RA01_22 (F3.0)
  RA01_23 (F3.0)
  RA02_01 (A256)
  TIME001 (F8.0)
  TIME002 (F8.0)
  TIME003 (F8.0)
  TIME004 (F8.0)
  TIME005 (F8.0)
  TIME006 (F8.0)
  TIME007 (F8.0)
  TIME008 (F8.0)
  TIME009 (F8.0)
  TIME010 (F8.0)
  TIME011 (F8.0)
  TIME_SUM (F8.0)
  MAILSENT (DATETIME)
  LASTDATA (DATETIME)
  FINISHED (F1.0)
  LASTPAGE (F8.0)
  MAXPAGE (F8.0)
  MISSING (F8.0)
  MISSREL (F8.0)
  DEG_MISS (F8.0)
  DEG_TIME (F8.0)
  DEGRADE (F8.0).
BEGIN DATA
224			NM	orgtest	24-02-2015 09:27:46	Test	22	2	xw5c	2	1	2	1	2	1	2	1	5	5	5	5	5	5	5	7	5	6	5	5	5	5	3	1	5	4	6	5	5	Test	20	3	3	5		4	7	9	3	5	28	87		24-02-2015 09:29:13	1	11	11	0	0	0	89	89	
225			NM	orgtest	24-02-2015 09:33:35	afaacsda	31	2	xw5c	1	1	1	1	1	2	1	1	2	1	2	3	1	3	3	3	4	4	4	2	5	4	2	4	1	2	7	1	7		88	13		7	13	6	12	6	9	9	73	236		24-02-2015 09:37:31	1	11	11	3	1	8	11	19	
226			NM	orgtest	24-02-2015 09:33:52	edsdf	28	2	xw5c	2	1	1	1	1	2	2	1	5	3	4	2	3	3	4	5	2	4	5	4	4	3	2	5	3	2	2	3	5		57	12	11	5	15	7	8	6		5	30	156		24-02-2015 09:36:28	1	11	11	3	1	8	19	27	
227			Her	orgtest	24-02-2015 09:34:41	z2ü?	28	2	xw5c	2	1	1	1	1	2	2	1	5	4	5	4	4	5	5	5	5	5	5	5	5	6	3	4	4	3	7	1	7	
Speech synthesis is sometimes stretched form too long pronounced words. Other than that, very nice. Maybe more active, eg facial expressions would be nice (my view as an uninformed participant).	110	229		9	14	12	11	8	12	9	194	
400		24-02-2015 09:44:49	1	11	11	0	0	0	0	0	
228			BL	orgtest	24-02-2015 09:45:34	dshsgd	30	2	xw5c	2	1	1	2	1	2	2	1	4	2	5	4	5	3	4	5	4	5	2	3	3	3	3	2	2	3	6	1	7		79	11	10	5	13	14	13	7		5	96	253		24-02-2015 09:49:47	1	11	11	3	1	8	7	15	
229			BL	orgtest	24-02-2015 10:08:31	blablabla	30	1	xw5c	2	1	2	1	1	2	2	1	6	1	4	6	5	1	1	1	1	7	7	1	7	1	4	6	1	4	7	1	7		94	48	24	7	28	10	12	9		8	170	410		24-02-2015 10:15:21	1	11	11	3	1	8	0	8	
231			Yu	orgtest	24-02-2015 10:15:24	1337	29	2	xw5c	2	2	1	1	1	2	2	2	5	3	6	6	5	4	4	6	7	4	7	5	5	6	2	7	2	6	6	1	6		85	32	18	9	31	33	26	9		9	110	324		24-02-2015 10:21:26	1	11	11	3	1	8	0	8	
239			BL	orgtest	24-02-2015 11:37:16		31	2	xw5c																															64											64		24-02-2015 11:38:20	0	1	1	25	23	200	0	200	
242			NM	orgtest	24-02-2015 12:07:58	a	27	2	xw5c	2	1	2	1	1	2	1	1	2	2	2	2	2	2	2	7	3	5	4	4	6	3	4	2	1	2	7	1	7		83	9	16	4	11	5	8	4		3	79	222		24-02-2015 12:11:40	1	11	11	3	1	8	26	34	
244			Yu	orgtest	24-02-2015 12:08:46	Cheating trick	99	1	xw5c	2	1	2	1	2	2	2	1	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5		59	21	4	7		12	3	4	2475	6	32	160		24-02-2015 12:52:29	1	11	11	3	1	8	34	42	
245			Yu	orgtest	24-02-2015 12:10:32		24	2	xw5c																															27											27		24-02-2015 12:10:59	0	1	1	25	23	200	62	262	
247			Yu	orgtest	24-02-2015 12:20:27	123456	24	2	xw5c	2	1	2	1	1	2	1	1	2	2	3	2	2	1	2	1	2	2	2	2	2	2	2	2	1	2	5	1	7	The head of Armandia's was always tilting, which was really disturbing	61	22	17	6	21	8	11	8		9	82	245		
24-02-2015 12:24:32	1	11	11	0	0	0	1	1	
249			Her	orgtest	24-02-2015 12:27:06	555	31	1	xw5c			2	1	1	2																									108	15			33	7		10				173		24-02-2015 12:29:59	0	6	8	0	0	0	8	8	
250			BL	orgtest	24-02-2015 12:40:24	qsdq	26	1	xw5c			1	1																											48	130				10						79		24-02-2015 12:43:32	0	6	6	0	0	0	4	4	
251			BL	orgtest	24-02-2015 12:47:47	42	29	2	xw5c	2	1	2	1	1	2	1	1	3	2	4	2	3	2	1	4	3	5	5	4	5	3	3	2	2	4	5	1	6	
the appearance is ok but its voice is too robotic and sometimes hard to understand because the transition between words is too quick	28	47	9	5		11	9	7	15	6	178	315		24-02-2015 12:53:02	1	11	11	0	0	0	8	8	
256			Her	orgtest	24-02-2015 13:01:38	Cheating trick	99	2	xw5c	2	1	2	1	1	2	1	1	5	2	3	3	4	6	5	3	7	1	7	4	1	7	4	4	6	2	1	5	5		25	4	2	5	2	6	3	6		5	76	134		24-02-2015 13:03:52	1	11	11	3	1	8	101	110	
257			NM	orgtest	24-02-2015 13:04:16	Cheating trick	10	1	xw5c	2	1	2	1	1	1	2	1	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4		21	36	48	7		19	14	15	12	6	24	158		24-02-2015 13:07:38	1	11	11	3	1	8	21	30	
258			Yu	orgtest	24-02-2015 13:14:57	azerty	31	2	xw5c	2	1	2	2	1	2	2	1	4	4	4	4	4	4	6	4	6	4	6	4	6	4	5	3	3	3	5	1	7		32	33		5	15	6	12	10	12	6	200	331		24-02-2015 13:20:28	1	11	11	3	1	8	8	16	
260			Yu	orgtest	24-02-2015 14:17:29	987	27	1	xw5c	2	1	2	1	1	2	2	1	4	3	4	4	4	4	3	5	5	4	4	5	5	4	5	5	4	5	5	2	6	You have to pay attention because the intonation doesn't emphasize the important information (time, day).	60	15	10	5	
15	10	10	5		5	308	443		24-02-2015 14:24:52	1	11	11	0	0	0	6	6	
262			BL	orgtest	24-02-2015 15:55:43	456	12	2	xw5c																															102											102		24-02-2015 15:57:25	0	1	1	0	0	0	0	0	
END DATA.


VARIABLE WIDTH  SERIAL REF QUESTNNR MODE IN01_01 IN02_01 IN04_01 RA02_01 (8)
 STARTED MAILSENT LASTDATA (20)
.


**** Variable und Value Labels *********************************************************************************************


VARIABLE LABELS
 CASE 'Interview number (ongoing)'
 SERIAL 'Serial number (if provided)'
 REF 'Reference (if provided in link)'
 QUESTNNR 'Questionnaire that has been used in the interview'
 MODE 'Interview mode'
 STARTED 'Time the interview has started'
 IN01_01 'CF_ID: [01]'
 IN02_01 'age: [01]'
 IN03 'gender'
 IN04_01 'Intro: login code'
 QU01 'shopping'
 QU02 'shopping2'
 QU03 'hawaii'
 QU04 'hawaii2'
 QU05 'garage'
 QU06 'garage2'
 QU07 'dentist'
 QU08 'dentist2'
 RA01_01 'likert scale: pleasant'
 RA01_02 'likert scale: sensitive'
 RA01_03 'likert scale: friendly'
 RA01_04 'likert scale: likeable'
 RA01_05 'likert scale: affable'
 RA01_06 'likert scale: approachable'
 RA01_07 'likert scale: sociable'
 RA01_08 'likert scale: dedicated'
 RA01_09 'likert scale: trustworthy'
 RA01_10 'likert scale: thorough'
 RA01_11 'likert scale: helpful'
 RA01_12 'likert scale: intelligent'
 RA01_13 'likert scale: organized'
 RA01_14 'likert scale: expert'
 RA01_15 'likert scale: active'
 RA01_16 'likert scale: humanlike'
 RA01_17 'likert scale: fun-loving'
 RA01_18 'likert scale: lively'
 RA01_21 'likert scale: english-speaking'
 RA01_22 'likert scale: blond'
 RA01_23 'likert scale: dark-haired'
 RA02_01 'feedback: [01]'
 TIME001 'Time spent on page 1'
 TIME002 'Time spent on page 2'
 TIME003 'Time spent on page 3'
 TIME004 'Time spent on page 4'
 TIME005 'Time spent on page 5'
 TIME006 'Time spent on page 6'
 TIME007 'Time spent on page 7'
 TIME008 'Time spent on page 8'
 TIME009 'Time spent on page 9'
 TIME010 'Time spent on page 10'
 TIME011 'Time spent on page 11'
 TIME_SUM 'Time spent overall (except outliers)'
 MAILSENT 'Time when the invitation mailing was sent (non-anonymous recipients, only)'
 LASTDATA 'Time when the data was most recently updated'
 FINISHED 'Status (has the interview been finished?)'
 LASTPAGE 'Last page that the participant has handled in the questionnaire'
 MAXPAGE 'Hindmost page handled by the participant'
 MISSING 'Missing answers in percent'
 MISSREL 'Missing answers (weighted by relevance)'
 DEG_MISS 'Degradation points for missing answers'
 DEG_TIME 'Degradation points for being very fast'
 DEGRADE 'Degradation points overall'
.


VALUE LABELS
 /IN03 1 'Female' 2 'Male' -9 'Not answered'
 /QU01 QU02 QU04 QU05 QU06 QU07 QU08 1 'Yes' 2 'No' -9 'Not answered'
 /QU03 1 'Train' 2 'Plane' -9 'Not answered'
 /RA01_01 RA01_02 RA01_03 RA01_04 RA01_05 RA01_06 RA01_07 RA01_08 RA01_09
 RA01_10 RA01_11 RA01_12 RA01_13 RA01_14 RA01_15 RA01_16 RA01_17 RA01_18
 RA01_21 RA01_22 RA01_23
 1 'not appropriate' 7 'very appropriate' -9 'Not answered'
 /FINISHED 0 'Canceled' 1 'Finished'
.

MISSING VALUES
 IN03 QU01 QU02 QU03 QU04 QU05 QU06 QU07 QU08 (-9,-8)
 RA01_01 RA01_02 RA01_03 RA01_04 RA01_05 RA01_06 RA01_07 RA01_08 RA01_09
 RA01_10 RA01_11 RA01_12 RA01_13 RA01_14 RA01_15 RA01_16 RA01_17 RA01_18
 RA01_21 RA01_22 RA01_23 (-9,-1)
.

