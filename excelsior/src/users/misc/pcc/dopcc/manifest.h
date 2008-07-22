# include <stdio.h>
/* manifest constant file for the lex/yacc interface */
/* SS. 03.07.86  added some Kronos specific macros */

# define ERROR 1
# define NAME 2
# define STRING 3
# define ICON 4
# define FCON 5
# define PLUS 6
# define MINUS 8
# define MUL 11
# define AND 14
# define OR 17
# define ER 19
# define QUEST 21
# define COLON 22
# define ANDAND 23
# define OROR 24

/* the defines for ASOP, RELOP, EQUOP, DIVOP,
   SHIFTOP, ICOP, UNOP, and STROP have been
   moved to mfile1    */
/* reserved words, etc */
# define TYPE 33
# define CLASS 34
# define STRUCT 35
# define RETURN 36
# define GOTO 37
# define IF 38
# define ELSE 39
# define SWITCH 40
# define BREAK 41
# define CONTINUE 42
# define WHILE 43
# define DO 44
# define FOR 45
# define DEFAULT 46
# define CASE 47
# define SIZEOF 48
# define ENUM 49


/* little symbols, etc. */
/* namely,

 LP (
 RP )

 LC {
 RC }

 LB [
 RB ]

 CM ,
 SM ;

 */

/*  These defines are being moved to mfile1
    to alleviate preprocessor problems with
    second pass files.  
# define LP 50
# define RP 51
# define LC 52
# define RC 53
*/
# define LB 54
# define RB 55
# define CM 56
# define SM 57
# define ASSIGN 58

/* END OF YACC */

/* left over tree building operators */
# define COMOP 59
# define DIV 60
# define MOD 62
# define LS 64
# define RS 66
# define DOT 68
# define STREF 69
# define CALL 70
# define FORTCALL 73
# define NOT 76
# define COMPL 77
# define INCR 78
# define DECR 79
# define EQ 80
# define NE 81
# define LE 82
# define LT 83
# define GE 84
# define GT 85
# define ULE 86
# define ULT 87
# define UGE 88
# define UGT 89
# define SETBIT 90
# define TESTBIT 91
# define RESETBIT 92
# define ARS 93
# define REG 94
# define OREG 95
# define CCODES 96
# define FREE 97
# define STASG 98
# define STARG 99
# define STCALL 100

/* some conversion operators */
# define FLD 103
# define SCONV 104
# define PCONV 105
# define PMCONV 106
# define PVCONV 107

/* special node operators, used for special contexts */
# define FORCE 108
# define CBRANCH 109
# define INIT 110
# define CAST 111

/* node types */
# define LTYPE 02
# define UTYPE 04
# define BITYPE 010

 /* DSIZE is the size of the dope array */
# define DSIZE CAST+1

/* type names, used in symbol table building */
# define TNULL PTR    /* pointer to UNDEF */
# define TVOID FTN /* function returning UNDEF (for void) */
# define UNDEF 0
# define FARG 1
# define CHAR 2
# define SHORT 3
# define INT 4
# define LONG 5
# define FLOAT 6
# define DOUBLE 7
# define STRTY 8
# define UNIONTY 9
# define ENUMTY 10
# define MOETY 11
# define UCHAR 12
# define USHORT 13
# define UNSIGNED 14
# define ULONG 15

# define ASG 1+
# define UNARY 2+
# define NOASG (-1)+
# define NOUNARY (-2)+

/* various flags */
# define NOLAB (-1)

/* type modifiers */

# define PTR  020
# define FTN  040
# define ARY  060

/* type packing constants */

# define TMASK 060
# define TMASK1 0300
# define TMASK2  0360
# define BTMASK 017
# define BTSHIFT 4
# define TSHIFT 2

/* macros */

# define MODTYPE(x,y) x = ( (x)&(~BTMASK))|(y)  /* set basic type of x to y */
# define BTYPE(x)  ( (x)&BTMASK)   /* basic type of x */
# define ISUNSIGNED(x) ((x)<=ULONG&&(x)>=UCHAR)
# define UNSIGNABLE(x) ((x)<=LONG&&(x)>=CHAR)
# define ENUNSIGN(x) ((x)+(UNSIGNED-INT))
# define DEUNSIGN(x) ((x)+(INT-UNSIGNED))
# define ISPTR(x) (( (x)&TMASK)==PTR)
# define ISFTN(x)  (( (x)&TMASK)==FTN)  /* is x a function type */
# define ISARY(x)   (( (x)&TMASK)==ARY)   /* is x an array type */
# define INCREF(x) ((( (x)&~BTMASK)<<TSHIFT)|PTR|( (x)&BTMASK))
# define DECREF(x) ((( (x)>>TSHIFT)&~BTMASK)|( (x)&BTMASK))
# define SETOFF(x,y)   if( (x)%(y) != 0 ) (x) = ( ((x)/(y) + 1) * (y))
  /* advance x to a multiple of y */
# define NOFIT(x,y,z)   ( ( (x)%(z) + (y) ) > (z) )
  /* can y bits be added to x without overflowing z */
 /* pack and unpack field descriptors (size and offset) */
# define PKFIELD(s,o) (( (o)<<6)| (s) )
# define UPKFSZ(v)  ( (v) &077)
# define UPKFOFF(v) ( (v) >>6)

/* operator information */

# define TYFLG 016
# define ASGFLG 01
# define LOGFLG 020

# define SIMPFLG 040
# define COMMFLG 0100
# define DIVFLG 0200
# define FLOFLG 0400
# define LTYFLG 01000
# define CALLFLG 02000
# define MULFLG 04000
# define SHFFLG 010000
# define ASGOPFLG 020000

# define SPFLG 040000

#define optype(o) (dope[o]&TYFLG)
#define asgop(o) (dope[o]&ASGFLG)
#define logop(o) (dope[o]&LOGFLG)
#define callop(o) (dope[o]&CALLFLG)


/* SS. 03.07.86  macros for Pass1 and Pass2 */

# define ISAGGREGATE(t)  (ISARY(t) || (t)==STRTY || (t)==UNIONTY)
# define ISCHAR(t)     (t==CHAR || t==UCHAR)
# define ISFLOAT(t) (t==FLOAT || t==DOUBLE)
# define commop(o)  (dope[o]&COMMFLG)
# define opasg(o)   (dope[o]&ASGOPFLG)
# define shiftop(o) (dope[o]&SHFFLG)
# define isfpreg(p)  (p->in.op==REG && p->tn.rval==STKREG)
# define isapreg(p)  (p->in.op==REG && p->tn.rval==ARGREG)
# define isitofs(val) ( (val) >= 0 && (val) <= 255 )

/* end of my patch */

/* table sizes */

# define TREESZ 500 /* SS. 11.Feb.87 was 350, space for building parse tree */

char *calloc();    /* SS. 28.nov.86 NB! was used(scan.c) but not declared*/
char *hash();
char *savestr();
char *tstr();
extern int tstrused;
extern char *tstrbuf[], **curtstr;
#define  freetstr() ( curtstr = tstrbuf, tstrused = 0 )

/* common defined variables */

extern int nerrors;  /* number of errors seen so far */

typedef union ndu NODE;
typedef unsigned int TWORD;
# define NIL (NODE *)0
extern int dope[];  /* a vector containing operator information */
extern char *opst[];  /* a vector containing names for ops */
extern unsigned int offsz,
      caloff();

 /* in one-pass operation, define the tree nodes */

union ndu {

 struct {
  int op;
  int rall;
  TWORD type;
  int su;
  char *name;
  int stalign;
  NODE *left;
  NODE *right;
  }in; /* interior node */
 
 struct {
  int op;
  int rall;
  TWORD type;
  int su;
  char *name;
  int stalign;
  CONSZ lval;
  int rval;
  }tn; /* terminal node */
 
 struct {
  int op, rall;
  TWORD type;
  int su;
  int label;  /* for use with branching */
  }bn; /* branch node */

 struct {
  int op, rall;
  TWORD type;
  int su;
  int stsize;  /* sizes of structure objects */
  int stalign;  /* alignment of structure objects */
  }stn; /* structure node */

 struct {
  int op;
  int cdim;
  TWORD type;
  int csiz;
  }fn; /* front node */
 
 struct {
  /* this structure is used when a floating point constant
     is being computed */
  int op;
  int cdim;
  TWORD type;
  int csiz;
  double dval;
  }fpn; /* floating point node */

 };

# ifdef BUG2
# define BUG1
# endif

# ifdef BUG3
# define BUG2
# define BUG1
# endif

# ifdef BUG4
# define BUG1
# define BUG2
# define BUG3
# endif
